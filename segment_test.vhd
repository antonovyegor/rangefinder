library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity segment_test is 
port(
C : in std_logic;
Segment: out std_logic_vector(7 downto 0);
Digit: out std_logic_vector(3 downto 0);
BUT1: in std_logic

);
end entity;



architecture BEH of segment_test is 
type CountType is array (3 downto 0) of natural range 0 to 9;
signal count : CountType:= (0,0,0,0);
signal digits : std_logic_vector(3 downto 0);
signal overflow : std_logic_vector(3 downto 0):="0000";
signal data : natural range 0 to 9 ; 

signal var_count : integer range 0 to 3:=0;
signal var_time_count : integer:=0;
signal PAUSE : std_logic :='0';

component NumberController 

port (
OE: in std_logic;
DataIN : in integer range 0 to 9;
Point : in std_logic;
DataOut : out std_logic_vector(7 downto 0)
);
end component;

begin
		process (BUT1)
		begin
		if falling_edge(BUT1) then 
		PAUSE<=not(PAUSE);
		end if;
		end process;
		
		
		process(C)
		variable ticks : integer:=0;
		begin 
		if rising_edge(C) and PAUSE='0' then 
			if ticks=50000 then
				ticks:=0;
				overflow(0)<='1';
			else
				ticks:=ticks+1;
				overflow(0)<='0';	
			end if;
		end if;
		end process;
		
		process(C,overflow)
		begin
			
			if rising_edge(C)  then
				if  overflow(0)='1' then 
					if count(0) = 9 then 
						count(0)<=0;
						overflow(1)<='1';
					else
						count(0)<=count(0) + 1;
					end if;
				end if;
		
				if  overflow(1)='1' then 
					overflow(1)<='0';
					if count(1) = 9 then 
						count(1)<=0;
						overflow(2)<='1';
					else
						count(1)<=count(1) + 1;
					end if;
				end if;
			
				if  overflow(2)='1' then
					overflow(2)<='0';
					if count(2) = 9 then 
						count(2)<=0;
						overflow(3)<='1';
					else
						count(2)<=count(2) + 1;
					end if;
				end if;
			
				if  overflow(3)='1' then
					overflow(3)<='0';
					if count(3) = 9 then 
						count(3)<=0;count(2)<=0;count(1)<=0;count(0)<=0;
					else
						count(3)<=count(3) + 1;
					end if;
				end if;
			end if;
				
		
		end process;
	

		
		process(C)
		begin	
				if rising_edge(C) then
					
					if var_time_count=300000 then 
						var_time_count<=0;
						if var_count = 3 then 
							var_count<=0;
						else 
							var_count<=var_count+1;
						end if;	
					else 
						var_time_count<=var_time_count+1;
					end if;
					
					
				end if;
				
				case var_count is 
						when 0 => digits<="1110"; data<=count(0); 
						when 1 => digits<="1101"; data<=count(1); 
						when 2 => digits<="1011"; data<=count(2); 
						when 3 => digits<="0111"; data<=count(3); 
				end case;
		end process;
		Digit<=digits;
		
		U1: NumberController port map (OE=>'1',Point=>'0',DataIN=>data, DataOut=>Segment);
	
		
end BEH;