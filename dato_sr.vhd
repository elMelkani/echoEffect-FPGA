library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
--ieee.numeric_std
--use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
--use work.pck_myhdl_08dev.all;

entity dato_sr is
	port( 
		clock : in std_logic;
		reset : in std_logic;
		dato_in : in std_logic;
		dato_out : out std_logic_vector (11 downto 0)
	);
end;

architecture behavioral of dato_sr is

signal dato_temp : std_logic_vector (15 downto 0);
signal enable : std_logic;

signal xin: std_logic_vector (11 downto 0);
signal xdelayed1: std_logic_vector (11 downto 0);
signal xdelayed2: std_logic_vector (11 downto 0);
signal rd_ptr: unsigned(13 downto 0);
signal wr_ptr: unsigned(13 downto 0);
signal new_ptr: unsigned(13 downto 0);
type t_array_mem is array(0 to 16384-1) of std_logic_vector (11 downto 0);
signal mem: t_array_mem;

begin

process(clock)
begin
if rising_edge(clock) then

	--This is the actual shift register
	if (reset = '1') then
		dato_temp <= (others => '0');
	else
		dato_temp(0) <= dato_in;
		dato_temp(1) <= dato_temp(0);
		dato_temp(2) <= dato_temp(1);
		dato_temp(3) <= dato_temp(2);
		dato_temp(4) <= dato_temp(3);
		dato_temp(5) <= dato_temp(4);
		dato_temp(6) <= dato_temp(5);
		dato_temp(7) <= dato_temp(6);
		dato_temp(8) <= dato_temp(7);
		dato_temp(9) <= dato_temp(8);
		dato_temp(10) <= dato_temp(9);
		dato_temp(11) <= dato_temp(10);
		dato_temp(12) <= dato_temp(11);
		dato_temp(13) <= dato_temp(12);
		dato_temp(14) <= dato_temp(13);
		dato_temp(15) <= dato_temp(14);
	end if;
end if;


end process;

process(clock)

variable temp : integer range 0 to 16;

begin

--This process activate the "enable" signal every 16 clock periods
if rising_edge(clock) then
	if (reset = '1') then
	temp := 0;
	enable <= '0';
	else
		temp := temp + 1;
		if (temp = 16) then
			enable <= '1';
		else
			enable <= '0';
		end if;
	end if;
end if;

end process;


--When the signal "enable" is high the 12 bit reading is stored in the output signal "dato_out"
process(clock)
variable echo : integer range 0 to 3;
begin
	if rising_edge(clock) then
		echo := 1;
		if (reset = '1') then
			dato_out <= (others => '0');
			rd_ptr <= "00000000000000";
			wr_ptr <= "00000000000000";
			new_ptr <= wr_ptr + 8192;
			xin <= (others => '0');
			xdelayed2 <= (others => '0');
			xdelayed1 <= (others => '0');
			--au_out <= (others => '0');
		else
			if (enable = '1') then
				if (rd_ptr /= wr_ptr) then
					rd_ptr <=wr_ptr;
				else
						xin <= dato_temp(11 downto 0);
						mem(to_integer(wr_ptr)) <= xin(11 downto 0);
						wr_ptr <= ((wr_ptr + 1) mod 16384);
						rd_ptr <= ((wr_ptr + 1) mod 16384);
						xdelayed2 <= '0' & mem(to_integer(rd_ptr))(10 downto 0);
						new_ptr <= ((wr_ptr + 8192) mod 16384);
						xdelayed1 <= mem(to_integer(new_ptr))(11 downto 0);
					if (echo = 0) then
						dato_out <= xin;
					elsif (echo = 1) then
						dato_out <= xin + xdelayed2;
					elsif (echo = 2) then
						dato_out <= xin +xdelayed1 + xdelayed2;
					end if;
				end if;					
			end if;
		end if;
	end if;

end process;

end behavioral;