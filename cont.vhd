library ieee;
use ieee.std_logic_1164.all;

entity sa is
	port (  clk, rst: in  std_logic;
		      clk_divided : out std_logic;
		      -- clk_divided2 : out std_logic;
		      -- clk_divided3 : out std_logic;
		      red : out std_logic_vector(15 downto 0);
	        green : out std_logic_vector(7 downto 0);
	        RL :in std_logic_vector(1 downto 0));
end entity sa;

architecture arc_sa of sa is
	constant DIV_BY : integer := 80000;--0000;
	constant IS_SWITCHED : std_logic := '0';
	signal cnt : integer range 0 to 80000;
--	signal cnt1 : integer range 10 to 20;
-- signal cnt2 : integer range 20 to 30;
	signal clk_divided1, clk_divided2, clk_divided3 : std_logic;
	
  begin
	sync : process (clk, rst)
		begin
			if rst = IS_SWITCHED then
				cnt <= 0;
			elsif clk'event AND clk='1' then
				if cnt = DIV_BY then
					cnt <= 0;
				else
					cnt <= cnt + 1;
				end if;
			end if;
	end process;
	-----------------------------------------------------------------------------------
	comb : process (cnt)
		begin
			if cnt < DIV_BY/2 then
				clk_divided1 <= '0';
				else
				clk_divided1 <= '1';
			end if;
	end process;
	-----------------------------------------------------------------------------------
	
	comb2 : process (cnt)
		begin
			if (cnt < DIV_BY/4) then
				clk_divided2 <= '0';
			elsif (cnt > DIV_BY/4 AND cnt < DIV_BY/2 ) then 
				clk_divided2 <= '1';
			elsif (cnt > DIV_BY/2 AND cnt < 3*DIV_BY/4) then
				clk_divided2 <= '0';
			else 
				 clk_divided2 <= '1'; 
			end if;
	end process;
	------------------------------------------------------------------------------------
	comb3 : process (cnt)
		begin
			if  (cnt < DIV_BY/8) then
				clk_divided3 <= '0';
				elsif (cnt > DIV_BY/8 AND cnt < DIV_BY/4 ) then
				clk_divided3 <= '1';
				elsif (cnt > DIV_BY/4 AND cnt < 3*DIV_BY/8 ) then
				clk_divided3 <= '0';
				elsif (cnt > 3*DIV_BY/8 AND cnt < DIV_BY/2 ) then
				clk_divided3 <= '1';
				elsif (cnt > DIV_BY/2 AND cnt < 5*DIV_BY/8 ) then
				clk_divided3 <= '0';
				elsif (cnt > 5*DIV_BY/8 AND cnt < 3*DIV_BY/4 ) then
				clk_divided3 <= '1';
				elsif (cnt > 3*DIV_BY/4 AND cnt < 7*DIV_BY/8 ) then
				clk_divided3 <= '0';
				else 
				 clk_divided3 <= '1';
			end if;
	end process;
	
	clk_divided <= clk_divided1 when RL = "00" else
	               clk_divided2 when RL = "01" else
	               clk_divided3 when RL = "10";

	--------------------------------------------------------------------------------------
		process(clk,rst)
		begin
		if rst = IS_SWITCHED then
			red <= "0000000000000000";
			green <= "00000000";
		elsif(rising_edge(clk)) then
		
			case RL is 
					when "01" => --01 circle
						red <= "1110011100111001";
						green <= "11001110";
					--wait;
					
					when "10"=> --square
						red <= "1111000011110000";
						green <= "11110000";
					when "00"=> --
						red <="1111111111111111";
						green<= "11111111";
					when "11"=> --stop
						red <="0000000000000000";
						green<= "00000000";
					-- when others => null;
			end case;

		end if;
	
		        
	end process;	
	----------------------------------------------------------
	
	-------------------------------------------------------

end architecture arc_sa;