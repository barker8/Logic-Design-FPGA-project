library ieee;
use ieee.std_logic_1164.all;

entity IU is	--IU - Input Unit
	port (switch, restN, fanD_switch :in std_logic; 
		 mov : in std_logic_vector (1 downto 0);
		 itinerary : out std_logic_vector (1 downto 0);
		 fanD_out : out std_logic
		);
end entity;

-- Inputs:
-- switch - system on/off switch
-- restN - reset 
-- fanD_switch - fan on/off switch
-- mov - input, the rout tipe.
-- Outputs:
-- itinerary - output, forward the rout tipe 
-- fanD_out -- output, fan switch

architecture IU_arc of IU is 

begin
	
	process (switch, restN)
	
		begin
		
		if switch = '0' then --switch off
			itinerary <= "11"; --stand still.
			fanD_out <= '0'; 

		elsif switch = '1' then --switch on
			if restN = '1' then --reset is off
				itinerary <= mov; --forward the rout tipe to the OG
				fanD_out <= fanD_switch; --system is on
				
			elsif restN = '0' then --reset the system
				itinerary <= "11"; --stand still
				fanD_out <= '0'; 
			end if;
		end if;	
				
	end process;
end architecture;	

library ieee;
use ieee.std_logic_1164.all;

entity OG is --orbital generation
	port (IU : in std_logic_vector (1 downto 0);
		 clk : in std_logic;
		 motion : out std_logic_vector (1 downto 0)
		);
end entity;

-- Inputs: 
-- IU - the itinerary
-- clk - clock
-- Outputs:
-- motion - command to the wheel controller

architecture OG_arc of OG is

constant n : integer  := 2000000;

signal counter : integer range 0 to n * 200; 



begin
	
	process (clk, IU, counter)  
	
	begin
	
		if rising_edge (clk) then 
	
			if IU = "00"  then --rout 1: forward/backwards
			counter <= 0;
				if counter < n * 20 then --10 Clock signals (*200ns)
				motion <= "00"; --forward
				counter <= counter + 1;
				elsif counter >= n * 20 AND counter < n * 30 then 
				motion <= "11"; --stop
				counter <= counter + 1;
				elsif counter >= n * 30 AND counter < n * 50 then 
				motion <= "01"; --backwards
				counter <= counter + 1;
				elsif counter >= n * 50 AND counter < n * 60 then 
				motion <= "11"; --stop
				counter <= counter + 1;
				end if;
		
			
		elsif IU = "01" then --rout 2: sqaure
			counter <= 0;
			if counter < n * 20 then 
				motion <= "00"; --forward
				counter <= counter + 1;
				
			elsif counter >= n * 20 AND counter < n * 60 then 
				motion <= "10"; --left turn
				counter <= counter + 1;
				--another 3 times to make the sqaure
				
			elsif counter >= n * 60 AND counter < n * 80 then 
				motion <= "00";
				counter <= counter + 1;
				
			elsif counter >= n * 80 AND counter < n * 120 then 
				motion <= "10";
				counter <= counter + 1;
				
			elsif counter >= n * 120 AND counter < n * 180 then 
				motion <= "00";
				counter <= counter + 1;
				
			elsif counter >= n * 180 AND counter < n * 220 then 
				motion <= "10";
				counter <= counter + 1;
				
			elsif counter >= n * 220 AND counter < n * 240 then 
				motion <= "00";
				counter <= counter + 1;
			elsif counter >= n * 240 AND counter < n * 280 then 
				motion <= "10";
				counter <= counter + 1;	
		
			else
				motion <= "11";
			end if;
		
		elsif IU = "10" then --rout 3: circle
			counter <= 0;
			if counter <= 10 then 
				motion <= "10"; --left turn
				counter <= counter + 1;
			end if;
			
		elsif IU = "11" then --rout 4: stop
			motion <= "11";
		end if;
	end if;	
		
	end process;
end architecture;			






		
		
		