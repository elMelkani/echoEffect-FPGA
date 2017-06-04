library ieee;
use ieee.std_logic_1164.all;

entity freq_div is
port( clock_in : in std_logic;
		clock_out : out std_logic);
end;

architecture behavioral of freq_div is

signal clock_temp : std_logic;

begin

clock_out <= clock_temp;

process(clock_in)

variable temp : integer range 0 to 20;
--variable cont_temp : integer range 0 to 3;

begin

--The input frequency is divided by 20
if rising_edge(clock_in) then
	temp := temp + 1;
	if (temp=20) then
		clock_temp <= not(clock_temp);
	end if;
end if;

end process;

end behavioral;