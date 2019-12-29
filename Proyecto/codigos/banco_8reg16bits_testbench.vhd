LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY banco_8reg16bits_testbench IS
END banco_8reg16bits_testbench;

ARCHITECTURE behavioral OF banco_8reg16bits_testbench IS

	COMPONENT banco_8reg16bits IS
		PORT(
			clk, reset, ld_reg : IN STD_LOGIC;
			data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			dr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			sr1, sr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			sr1out, sr2out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
		
		SIGNAL clk, reset, wr_en : STD_LOGIC;
		SIGNAL w_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
		SIGNAL w_addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
		SIGNAL r_addr0, r_addr1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
		SIGNAL r_data0, r_data1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
		
	BEGIN
		-- instantiale the circuit under test
		uut : banco_8reg16bits PORT MAP(clk, reset, wr_en, w_data, w_addr,
												  r_addr0, r_addr1, r_data0, r_data1);
		
		-- test vector generator
		PROCESS
		BEGIN
		
			reset <= '1';
			
			-- storage a value in addr7
			WAIT FOR 50 ps;
			clk <= '0';
			reset <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "111"; -- enable addr7
			w_data <= x"0001"; -- 1 en decimal
			r_addr0 <= "111"; -- put value from addr7 on r_data0
			r_addr1 <= "111"; -- put value from addr7 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
			
			-- storage a value in addr6
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "110"; -- enable addr6
			w_data <= x"3039"; -- 12345 en decimal
			r_addr0 <= "111"; -- put value from addr7 on r_data0
			r_addr1 <= "111"; -- put value from addr7 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
			
			-- storage a value in addr5
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "101"; -- enable addr5
			w_data <= x"a06b"; -- (-24469) en decimal
			r_addr0 <= "111"; -- put value from addr1 on r_data0
			r_addr1 <= "111"; -- put value from addr0 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
			
			-- storage a value in addr4
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "100"; -- enable addr4
			w_data <= x"205b"; -- enable 8283 en decimal
			r_addr0 <= "110"; -- put value from addr6 on r_data0
			r_addr1 <= "101"; -- put value from addr5 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
			
			-- storage a value in addr3
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "011"; -- enable addr3
			w_data <= x"00ff"; -- 255 en decimal
			r_addr0 <= "100"; -- put value from addr4 on r_data0
			r_addr1 <= "111"; -- put value from addr7 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1'; -- time = 500ps --
			
			-- storage a value in addr2
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "010"; -- enable addr2
			w_data <= x"5555"; -- 21845 en decimal
			r_addr0 <= "100"; -- put value from addr4 on r_data0
			r_addr1 <= "101"; -- put value from addr5 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
			
			-- storage a value in addr1
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "001"; -- enable addr1
			w_data <= x"a2d2"; -- (-23854) en decimal
			r_addr0 <= "001"; -- put value from addr1 on r_data0
			r_addr1 <= "111"; -- put value from addr7 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
			
			-- storage a value in addr0
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '1'; -- enable for write
			w_addr <= "000"; -- enable addr0
			w_data <= x"0003"; -- 3 en decimal
			r_addr0 <= "001"; -- put value from addr1 on r_data0
			r_addr1 <= "011"; -- put value from addr3 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
			
			-- reset all
			WAIT FOR 20 ps; reset <= '1';
			-- storage a value in addr3
			WAIT FOR 30 ps;
			clk <= '0';
			reset <= '0';
			wr_en <= '0'; -- enable for write
			w_addr <= "011"; -- enable addr3
			w_data <= x"3333"; -- 13107 en decimal
			r_addr0 <= "011"; -- put value from addr3 on r_data0
			r_addr1 <= "000"; -- put value from addr0 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1'; -- time = 1 ns --
			
			-- storage a value in addr0
			WAIT FOR 50 ps;
			clk <= '0';
			wr_en <= '0'; -- unenable for write
			w_addr <= "000"; -- enable addr0
			w_data <= x"0003"; -- 3 en decimal
			r_addr0 <= "011"; -- put value from addr3 on r_data0
			r_addr1 <= "000"; -- put value from addr0 on r_data1
			-- execute the transference
			WAIT FOR 50 ps; clk <= '1';
	
			-- Simulation total time = 1.1 ns
			
	END PROCESS;
	
END behavioral;