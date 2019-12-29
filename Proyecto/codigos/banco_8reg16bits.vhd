LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY banco_8reg16bits IS
	PORT(
		clk, reset, ld_reg : IN STD_LOGIC;
		data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		dr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		sr1, sr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		sr1out, sr2out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END banco_8reg16bits;

ARCHITECTURE behavioral OF banco_8reg16bits IS
	
	SIGNAL dec_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL r0_next, r0_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL r1_next, r1_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL r2_next, r2_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL r3_next, r3_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL r4_next, r4_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL r5_next, r5_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL r6_next, r6_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL r7_next, r7_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	BEGIN
	
		-- register
		PROCESS(clk, reset)
			BEGIN
			IF (reset='1') THEN
				r0_reg <= (OTHERS =>'0');
				r1_reg <= (OTHERS =>'0');
				r2_reg <= (OTHERS =>'0');
				r3_reg <= (OTHERS =>'0');
				r4_reg <= (OTHERS =>'0');
				r5_reg <= (OTHERS =>'0');
				r6_reg <= (OTHERS =>'0');
				r7_reg <= (OTHERS =>'0');
			ELSIF (clk'EVENT and clk='1') THEN
				r0_reg <= r0_next;
				r1_reg <= r1_next;
				r2_reg <= r2_next;
				r3_reg <= r3_next;
				r4_reg <= r4_next;
				r5_reg <= r5_next;
				r6_reg <= r6_next;
				r7_reg <= r7_next;
			END IF;
		END PROCESS;
		
		-- next-state logic
		r0_next <= data WHEN dec_out(0) = '1' ELSE r0_reg;
		r1_next <= data WHEN dec_out(1) = '1' ELSE r1_reg;
		r2_next <= data WHEN dec_out(2) = '1' ELSE r2_reg;
		r3_next <= data WHEN dec_out(3) = '1' ELSE r3_reg;
		r4_next <= data WHEN dec_out(4) = '1' ELSE r4_reg;
		r5_next <= data WHEN dec_out(5) = '1' ELSE r5_reg;
		r6_next <= data WHEN dec_out(6) = '1' ELSE r6_reg;
		r7_next <= data WHEN dec_out(7) = '1' ELSE r7_reg;
					 	
		-- decoder
		WITH ld_reg & dr SELECT
			dec_out <= x"80" WHEN '1' & "111",
							x"40" WHEN '1' & "110",
							x"20" WHEN '1' & "101",
							x"10" WHEN '1' & "100",
							x"08" WHEN '1' & "011",
							x"04" WHEN '1' & "010",
							x"02" WHEN '1' & "001",
							x"01" WHEN '1' & "000",
							x"00" WHEN OTHERS;
		-- MUX1
		WITH sr1 SELECT
			sr1out <= r7_reg WHEN "111",
							r6_reg WHEN "110",
							r5_reg WHEN "101",
							r4_reg WHEN "100",
							r3_reg WHEN "011",
							r2_reg WHEN "010",
							r1_reg WHEN "001",
							r0_reg WHEN OTHERS;
		
		-- MUX2
		WITH sr2 SELECT
			sr2out <= r7_reg WHEN "111",
							r6_reg WHEN "110",
							r5_reg WHEN "101",
							r4_reg WHEN "100",
							r3_reg WHEN "011",
							r2_reg WHEN "010",
							r1_reg WHEN "001",
							r0_reg WHEN OTHERS;
		
END behavioral;