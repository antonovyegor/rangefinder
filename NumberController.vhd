library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;



entity NumberController is 

port (
OE: in std_logic;
DataIN : in integer range 0 to 9;
Point : in std_logic;
DataOut : out std_logic_vector(7 downto 0)
);
end entity;


architecture BEH of NumberController is 

signal DataOutSig : std_logic_vector(7 downto 0);
begin 
		process(DataOutSig)
		begin
		if OE = '1' then 
					DataOut<=not(DATaOutSig);
		else 		DATaOut<=X"FF";
		end if;
		end process;

		
		
		process (DataIN)
		begin
		case DataIN is 
			when 0 => DataOutSig<="1111110" & Point ; 
			when 1 => DataOutSig<="0110000" & Point ; 
			when 2 => DataOutSig<="1101101" & Point ; 
			when 3 => DataOutSig<="1111001" & Point ; 
			when 4 => DataOutSig<="0110011" & Point ; 
			when 5 => DataOutSig<="1011011" & Point ; 
			when 6 => DataOutSig<="1011111" & Point ; 
			when 7 => DataOutSig<="1110000" & Point ; 
			when 8 => DataOutSig<="1111111" & Point ; 
			when 9 => DataOutSig<="1111011" & Point ; 
		end case;
		end process;
end BEH;