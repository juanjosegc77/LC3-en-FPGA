LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY alu_testbench IS
END alu_testbench;

ARCHITECTURE behavioral OF alu_testbench IS

	COMPONENT alu
		PORT(
			ALUK : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			A, B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
		
		SIGNAL ALUK : std_logic_vector(1 DOWNTO 0);
		SIGNAL A, B : std_logic_vector(15 DOWNTO 0);
		SIGNAL Y : std_logic_vector(15 DOWNTO 0);

	BEGIN
		-- instantiale the circuit under test
		uut : alu
		PORT MAP(ALUK => ALUK, A => A, B => B, Y => Y);
		
		-- test vector generator
		PROCESS
		BEGIN
			
			-- Y = A+B (complemento a 2)
			WAIT FOR 100 ps;
			ALUK <= "00";
			A <= x"0003"; -- 3 en decimal
			B <= x"000a"; -- 10 en decimal
			
			WAIT FOR 100 ps;
			A <= x"0044"; -- 68 en decimal
			B <= x"008f"; -- 143 en decimal
			
			WAIT FOR 100 ps;
			A <= x"3039"; -- 12345 en decimal
			B <= x"a06b"; -- (-24469) en decimal
			
			WAIT FOR 100 ps;
			A <= x"a2d2"; -- (-23854) en decimal
			B <= x"205b"; -- 8283 en decimal
			
			
			-- y = not A
			WAIT FOR 100 ps;
			ALUK <= "01";
			A <= "0000000011111111";
			
			WAIT FOR 100 ps;
			A <= "0101010101010101";
			
			WAIT FOR 100 ps;
			A <= "0011001100110011";
			
			WAIT FOR 100 ps;
			A <= "0011101010101010";
			
			-- Y = A
			WAIT FOR 100 ps;
			ALUK <= "10";
			A <= "0000000011111111";
			
			WAIT FOR 100 ps;
			A <= "0101010101010101";
			
			WAIT FOR 100 ps;
			A <= "0011001100110011";
			
			WAIT FOR 100 ps;
			A <= "0011101010101010";
			
			-- Y = A and B
			WAIT FOR 100 ps;
			ALUK <= "11";
			A <= x"FFFF"; -- (-1) en decimal
			B <= x"0000";
			
			WAIT FOR 100 ps;
			A <= x"0044"; -- 68 en decimal
			B <= x"008f"; -- 143 en decimal
			
			WAIT FOR 100 ps;
			A <= x"3039"; -- 12345 en decimal
			B <= x"a06b"; -- (-24469) en decimal
			
			WAIT FOR 100 ps;
			A <= x"a2d2"; -- (-23854) en decimal
			B <= x"205b"; -- 8283 en decimal
			
			-- Tiempo total de simulacion = 1.7 ns
			
	END PROCESS;
	
END behavioral;