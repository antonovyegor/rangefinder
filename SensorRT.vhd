library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity SensorRT is 
port (
Clock : in std_logic;
EN : in std_logic;
Trig: out std_logic;
Echo : in std_logic;
Data : out natural;
Ready : out std_logic
);
end entity ;


architecture SYN of SensorRT is 
type state is (Idle,Trans, Waiting, Rec);
signal fsm : state := idle;
signal count : integer := 0;
begin

process (Clock, EN)
begin 

	if rising_edge(clock) then
		case fsm is 
			when  idle => 
					if EN='1' then 
						fsm<=Trans;
						count <= 0;
						Ready<='0';
						TRIg<='0';
						Data<=0;
					end if;
			when Trans => 
					if count = 50 then 
						Trig<='0';
						count<=0;
						fsm<= waiting;
					else 
						Trig<='1';
						count<=count+1;
					end if;
			when Waiting =>
					if Echo ='1' then fsm<=Rec; end if; 
			when Rec => 
					if Echo = '1' then 
						count<=count+1;
					else 
						fsm<= idle ;
						Ready<='1';
						Data<= count / 2900; --  58 * 50 
					end if;
		end case ;
	end if;	
end process;
end SYN;