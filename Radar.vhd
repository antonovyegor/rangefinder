library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Radar is 

port (
	Clock : in std_logic;
	SensorTrig : out std_logic;
	SensorEcho : in std_logic;
	
	Digits_out : out std_logic_vector(0 to 3);
	Segment_out : out std_logic_vector (0 to 7)
);
end entity ; 

architecture SYN of RAdar is 
		
		component SensorRt 
		port (
			Clock : in std_logic;
			EN : in std_logic;
			Trig: out std_logic;
			Echo : in std_logic;
			Data : out natural;
			Ready : out std_logic
		);
		end component;
		
		component NumberController
		port (
			OE: in std_logic;
			DataIN : in integer range 0 to 9;
			Point : in std_logic;
			DataOut : out std_logic_vector(7 downto 0)
		);
		end component;
		
		subtype number is  integer range 0 to 9 ;
		type numbers  is array (0 to 3 ) of  number ; 
		type state is (idle , P1 , P2, P3, P4);
		
		
		signal sensor_data : natural ;
		signal sensor_ready : std_logic;
		
		signal fsm : state := idle;
		
		signal enable : std_logic:= '0';
		
		signal numbers_array : numbers;
		signal segment_data : number;
begin 
		
		U1 : SensorRt 
		port map (
			Clock => Clock,
			EN => enable,
			Trig=> SensorTrig,
			Echo=> SensorEcho,
			Data=>sensor_data,
			Ready=> sensor_ready
		);
		
		U2: NumberController 
		port map (
			OE=>'1',
			Point=>'1',
			DataIN=>segment_data, 
			DataOut=>segment_out
		);
		
		process(Clock)
			variable count : integer range 0 to 3:=0;
			variable time_count : integer:=0;
		begin	
				if rising_edge(Clock) then
					
					if time_count=250000 then 
						time_count:=0;
						if count = 3 then 
							count:=0;
						else 
							count:=count+1;
						end if;	
					else 
						time_count:=time_count+1;
					end if;
				
				
					case count is 
						when 0 => digits_out<="1110"; segment_data<=numbers_array(0); 
						when 1 => digits_out<="1101"; segment_data<=numbers_array(1); 
						when 2 => digits_out<="1011"; segment_data<=numbers_array(2); 
						when 3 => digits_out<="0111"; segment_data<=numbers_array(3);
					end case;
				
				end if;
				
		end process;
		
		
		
		process (Clock)
			variable count : natural := 0 ; 
		begin
				if rising_edge(Clock) then 
					if count = 50000000 then 
						count:=0;
						enable <= '1' ;
					else count:= count +1 ;
							enable<= '0' ;
					end if;
				end if;
				
		end process;

		
		process (Clock)
			variable data : natural;
			variable count : natural := 0 ;
			variable digit : natural range 0 to 10 := 0;
		begin
			if rising_edge(clock) then
				case fsm is 
					when idle => 
						if sensor_ready = '1' then 
							data:=sensor_data; 
							fsm<=P1; 
							count:=0; 
						end if;
					when P1 => 
						if count <= data then 
							count:=count + 1000 ;
							digit := digit + 1;
						else 
							numbers_array(0)<=digit - 1 ;
							count:= count - 1000;
							digit :=0;	
							fsm <= P2 ;
						end if;
					when P2 => 
						if count <= data then 
							count:=count + 100 ;
							digit := digit + 1;
						else 
							numbers_array(1)<=digit - 1 ;
							count:= count - 100; 
							digit := 0;
							fsm <= P3 ;
						end if;
					when P3 => 
						if count <= data then 
							count:=count + 10 ;
							digit := digit + 1;
						else 
							numbers_array(2)<=digit-1;
							count:= count - 10; 
							digit := 0;
							fsm <= P4 ;
						end if;
					when P4 => 
						if count <= data then 
							count:=count + 1 ;
							digit := digit + 1;
						else 
							numbers_array(3)<=digit-1;
							count:= 0; 
							digit := 0;
							fsm <= idle ;
						end if;
					end case ;
			end if;
		end process;
end SYN;