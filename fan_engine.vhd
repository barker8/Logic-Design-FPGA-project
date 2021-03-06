library IEEE;
use IEEE.std_logic_1164.all;

entity fan_engine is
port (clk, rst, rl : in    std_logic;
      onoff        : in    std_logic_vector (1 downto 0);
      fan_vel      : out std_logic_vector (1 downto 0)
);
end entity;

architecture fan_arc of fan_engine is 

type f_state is (v1, v2);
type t_state is (up, dow);
signal state : f_state;
signal state1 : t_state;
signal count : integer := 0;
signal count2 : integer := 0;

procedure clkdiv (signal counter : inout integer;
                  constant goval : in integer;
                  velval : in std_logic;
                  tostate : in t_state;
                  signal velocity : out std_logic;
                  signal state: out t_state) is
       begin
            velocity <= velval;
             if counter =  goval then
                 state <= tostate;
                 counter <= 0;
              end if;
end procedure;   

begin
process (clk, rst, rl)
begin

if rst='0' or onoff="11" then
fan_vel <= "00";
count <= 0;
count2 <= 0;
state <= v1;
state1 <= up;

elsif rising_edge(clk) then 

count <= count + 1;
count2 <= count2 + 1;

 if rl = '1' then
 fan_vel(1) <= '0';
   case state is
        when v1 =>
		 case state1 is
		     when up =>
                         clkdiv(count2, 1000, '1', dow, fan_vel(0), state1);
		     when dow => 
                      clkdiv(count2, 9000, '0', up, fan_vel(0), state1);
		end case;		
				
        if count = 25e6 then
         count <= 0;
	     count2 <= 0;
	     state <= v2;
        end if;
	
        when v2 =>
		 case state1 is
		     when up =>
                 clkdiv(count2,9000, '1', dow, fan_vel(0), state1);
		
		      when dow => 
		         clkdiv(count2,1000, '0', up, fan_vel(0), state1);
		end case;
		
          if count = 25e6 then
		     count <= 0;
		     count2 <= 0;
		     state <= v1;
		  end if;
	end case;  
		
 elsif rl='0' then
  fan_vel(0) <= '0';
    case state is
        when v1 =>
		 case state1 is
		     when up =>
                          clkdiv(count2,1000, '1', dow, fan_vel(1), state1);
		     when dow => 
                          clkdiv(count2,9000, '0', up, fan_vel(1), state1);
	    	end case;	
			
         if count = 25e6 then
	      count <= 0;
	      count2 <= 0;
	      state <= v2;
	     end if;
			  
        when v2 =>
		 case state1 is
		     when up =>
                         clkdiv(count2,9000, '1', dow, fan_vel(1), state1);
		      when dow => 
                         clkdiv(count2,1000, '0', up, fan_vel(1), state1);
			end case;	
              if count = 25e6 then
		       count <= 0;
		       count2 <= 0;
		       state <= v1;
		     end if;
		end case;	 
  end if;
end if;

end process;

end architecture;   
