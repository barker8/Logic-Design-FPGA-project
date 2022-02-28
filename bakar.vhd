library ieee;
use ieee.std_logic_1164.all;

entity bakar is
	port(CLK : in std_logic;
	     x   : in std_logic_vector (1 downto 0);
	     fr  : out std_logic_vector (1 downto 0);
	     fl  : out std_logic_vector (1 downto 0);
	     br  : out std_logic_vector (1 downto 0);
	     bl  : out std_logic_vector (1 downto 0));
end entity bakar;

architecture bakar_arc of bakar is
	begin
		process(CLK,x)
		  begin
			if rising_edge(CLK) then
			   if To_x01(x) = "00" then
				fr <= "10";
				fl <= "10";
				br <= "10";
				bl <= "10";
			   elsif To_x01(x) = "01" then
				fr <= "01";
				fl <= "01";
				br <= "01";
				bl <= "01";
			   elsif To_x01(x) = "10" then
				fr <= "10";
				fl <= "01";
				br <= "10";
				bl <= "01";
			   else
				fr <= "00";
				fl <= "00";
				br <= "00";
				bl <= "00";
			   end if;
			end if;
		end process;
end architecture;