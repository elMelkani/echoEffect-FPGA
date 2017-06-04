library ieee;
use ieee.std_logic_1164.all;

entity driver_adc is
port(	clock_50 : in std_logic;--clock from the 50Mhz oscillator
		reset : in std_logic;
		dato_in : in std_logic;
		dato : out std_logic_vector (11 downto 0);
		--the following signals must be mapped directly to the ADC
		clock_2 : out std_logic;--ADC clock (ADC_SCLK)
		address : out std_logic;--channel address (ADC_SADDR)
		ground : out std_logic;
		powerer : out std_logic;
		chip_select : out std_logic);--this signal activate the ADC chip (ADC_CS_N)
end;


architecture beh of driver_adc is

signal clock_2_temp : std_logic;


-- This component simply takes the clock from the oscillator (50MHz) and outputs a clock with a lower frequency
--(the ADC clock ranges from 0.8 MHz to 3.2 MHz)
component freq_div is
port( clock_in : in std_logic;
		clock_out : out std_logic);
end component;


-- This is a shift register.
--The ADC outputs one bit each clock period.
--After 12 periods the shift register has stored the complete 12 bits voltage reading.
--(actually every 16 periods because the reading is always preceded by 4 zeros for some reason)
component dato_sr is
port( clock : in std_logic;
		reset : in std_logic;
		dato_in : in std_logic;
		dato_out : out std_logic_vector (11 downto 0));
end component;

begin

--The ADC can convert the voltage from 8 different channels.
--Here I fixed the address to 0 because I only had one voltage to read.
address <= '0';
ground <= '0';
powerer <= '1';
--This signal activate the ADC chip
chip_select <= reset;

clock_2 <= clock_2_temp;

fd1 : freq_div port map (clock_in=>clock_50,clock_out=>clock_2_temp);

sr1 : dato_sr port map (clock=>clock_2_temp,reset=>reset,dato_in=>dato_in,dato_out=>dato);

end beh;