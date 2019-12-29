LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY lc3_testbench IS
END lc3_testbench;

ARCHITECTURE behavioral OF lc3_testbench IS

	COMPONENT lc3 IS
		PORT(
			clk, reset : IN STD_LOGIC;
			data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
		
		SIGNAL clk, reset : STD_LOGIC;
		SIGNAL data_in, data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
		
	BEGIN
		-- instantiale the circuit under test
		uut : lc3 PORT map(clk, reset, data_in, data_out);
		
		-- test vector generator
		PROCESS
		BEGIN
			
			-- initial time
			reset <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 500 ps
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 1 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 1.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 2 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 2.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 3 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 3.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 4 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 4.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 5.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 6 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 6.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 7 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 7.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 8 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 8.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 9 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 9.5 ns
			
			WAIT FOR 50 ps; clk <= '0';
			reset <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';

			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			WAIT FOR 50 ps; clk <= '0';
			WAIT FOR 50 ps; clk <= '1';
			
			--------------------------------------------- 10 ns
			
			-- Simulation total time = 8.3 ns
			
	END PROCESS;
	
END behavioral;