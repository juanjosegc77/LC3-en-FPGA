LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY cond_cod_testbench IS
END cond_cod_testbench;

ARCHITECTURE behavioral OF cond_cod_testbench IS

	COMPONENT cond_cod IS
	PORT(
		clk, reset, ld_cc : IN std_logic;
		data : IN std_logic_vector(15 DOWNTO 0);
		ir : IN std_logic_vector(11 DOWNTO 9);
		n, z, p, ben : OUT std_logic
	);
	END COMPONENT;
	
	SIGNAL clk, reset, ld_cc : STD_LOGIC;
	SIGNAL data : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ir : std_logic_vector(11 DOWNTO 9);
	SIGNAL n, z, p : STD_LOGIC;
	
	BEGIN
	
	uut : cond_cod PORT MAP(clk, reset, ld_cc, data, ir, n, z, p);
	
	PROCESS
		BEGIN
		
		-- ir[11:9] = NZP
		
		-- initial conditions
		reset <= '1';
		ld_cc <= '1';
		
		------------ data EQUAL TO ZERO ------------
		-- ir = 100
		WAIT FOR 50 ps; clk <= '0';
		reset <= '0';
		data <= x"0000";
		ir <= "100";
		WAIT FOR 50 ps; clk <= '1';
		
		-- ir = 010
		WAIT FOR 50 ps; clk <= '0';
		ir <= "010";
		WAIT FOR 50 ps; clk <= '1';
		
		-- ir = 001 => BEN = 0
		WAIT FOR 50 ps; clk <= '0';
		ir <= "001";
		WAIT FOR 50 ps; clk <= '1';
		
		------------ NEGATIVE data------------
		-- ir = 100
		WAIT FOR 50 ps; clk <= '0';
		data <= x"9a6b"; -- (-26005) ld_reg decimal
		ir <= "100";
		WAIT FOR 50 ps; clk <= '1';
		
		-- ir = 010
		WAIT FOR 50 ps; clk <= '0';
		ir <= "010";
		WAIT FOR 50 ps; clk <= '1'; -- 500 ps
		
		-- ir = 001
		WAIT FOR 50 ps; clk <= '0';
		ir <= "001";
		WAIT FOR 50 ps; clk <= '1';
		
		
		------------ POSITIVE data------------
		-- ir = 100
		WAIT FOR 50 ps; clk <= '0';
		data <= x"35a5"; -- 13733 ld_reg decimal
		ir <= "100";
		WAIT FOR 50 ps; clk <= '1';
		
		-- ir = 010
		WAIT FOR 50 ps; clk <= '0';
		ir <= "010";
		WAIT FOR 50 ps; clk <= '1';
		
		-- ir = 001
		WAIT FOR 50 ps; clk <= '0';
		ir <= "001";
		WAIT FOR 50 ps; clk <= '1';
		
		-- simulation total time 900 ps
		
	END PROCESS;
END behavioral;
		