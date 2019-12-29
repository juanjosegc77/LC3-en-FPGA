LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY lc3 IS
	PORT(
		clk, reset : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END lc3;

ARCHITECTURE behavioral OF lc3 IS
	
	---------- COMPONENT alu ----------
	COMPONENT alu IS
		PORT(
			aluk : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			a, b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	
	---------- COMPONENT banco_8reg16bits ----------
	COMPONENT banco_8reg16bits IS
		PORT(
			clk, reset, ld_reg : IN STD_LOGIC;
			data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			dr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			sr1, sr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			sr1out, sr2out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	
	---------- COMPONENT cond_cod ----------
	COMPONENT cond_cod IS
		PORT(
			clk, reset, ld_cc : IN std_logic;
			data : IN std_logic_vector(15 DOWNTO 0);
			ir : IN std_logic_vector(11 DOWNTO 9);
			n, z, p, ben : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT ram IS
		PORT (
        clk : IN STD_LOGIC;
        r_w, mem_en : IN STD_LOGIC;
        ram_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        addr_ram : IN INTEGER RANGE 0 TO 65535;
        ram_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;
	
	-- STATES
	TYPE state_type IS (e0, e1, e2, e3, e4, e5, e6, e7         , e9, e10,
							  e11, e12,      e14, e15, e16,      e18,      e20,
							  e21, e22, e23, e24, e25, e26, e27, e28, e29, e30,
							  e31, e32, e33,      e35);
	SIGNAL state_reg, state_next : state_type;
	
	-- CONTROL REGISTER
	SIGNAL mar_reg, mar_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL mdr_reg, mdr_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ir_reg, ir_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL pc_reg, pc_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ben_reg, ben_next : STD_LOGIC;
	SIGNAL kbdr_reg, kbdr_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL kbsr_reg, kbsr_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ddr_reg, ddr_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL dsr_reg, dsr_next : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	-- SIGNALS
	SIGNAL datapath : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
	SIGNAL dr, sr1, sr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sr1out, sr2out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL sr2mux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL n, z, p, ben : STD_LOGIC;
	SIGNAL alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL add : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL addr1mux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL addr2mux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL pcmux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL marmux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ram_in, ram_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL addr_ram : INTEGER RANGE 0 TO 65535;
	SIGNAL mioen, inmux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL logic_control : STD_LOGIC_VECTOR(5 DOWNTO 0);
	
	-- 1 BIT CONTROL SIGNALS
	SIGNAL ld_mar, ld_mdr, ld_ir, ld_ben, ld_reg, ld_cc, ld_pc,
			 gate_pc, gate_mdr, gate_alu, gate_mar_mux,
			 addr1_mux, mar_mux, r_w, mio_en, mem_en, sr2_mux,
			 ld_kbsr, ld_dsr, ld_ddr : STD_LOGIC;
			 
	-- 2 BITS CONTROL SIGNALS
	SIGNAL pc_mux, dr_mux, sr1_mux, addr2_mux, aluk, in_mux : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	-- BEGIN ARCHITECTURE
	BEGIN
	
	-- MAKE COMPONENTS
	uut_alu : alu PORT MAP(aluk, sr1out, sr2mux, alu_out);
	
	uut_banco : banco_8reg16bits PORT MAP(clk, reset, ld_reg, datapath,
													  dr, sr1, sr2, 
													  sr1out, sr2out);
	
	uut_cond_cod : cond_cod PORT MAP(clk, reset, ld_cc, datapath,
												ir_reg(11 DOWNTO 9), n, z, p, ben);
	
	uut_ram : ram PORT MAP(clk, r_w, mem_en, ram_in, addr_ram, ram_out);
	
	-- add
	add <= STD_LOGIC_VECTOR(UNSIGNED(addr1mux) + UNSIGNED(addr2mux));
	
	-- pcmux
	pcmux <= STD_LOGIC_VECTOR(UNSIGNED(pc_reg) + 1) WHEN pc_mux = "00" ELSE
			   add WHEN pc_mux = "01" ELSE
				datapath;
	
	-- drmux
	WITH dr_mux SELECT
		dr <= ir_reg(11 DOWNTO 9) WHEN "00",
				"110" WHEN "01",
				"111" WHEN OTHERS;
				
	-- sr1mux
	WITH sr1_mux SELECT
		sr1 <= ir_reg(11 DOWNTO 9) WHEN "00",
				ir_reg(8 DOWNTO 6) WHEN "01",
				"110" WHEN OTHERS;
				
	-- sr2
	sr2 <= ir_reg(2 DOWNTO 0);
	
	-- sr2mux
	sr2mux <= sr2out WHEN sr2_mux = '0' ELSE 
				 "00000000000" & ir_reg(4 DOWNTO 0) WHEN ir_reg(4) = '0' ELSE
				 "11111111111" & ir_reg(4 DOWNTO 0);
	
	-- addr1mux
	addr1mux <= pc_reg WHEN addr1_mux = '0' ELSE sr1out;
	
	-- addr2mux
	addr2mux <= x"0000" WHEN addr2_mux = "00" ELSE
					"0000000000" & ir_reg(5 DOWNTO 0) WHEN addr2_mux = "01" AND ir_reg(5) = '0' ELSE
					"1111111111" & ir_reg(5 DOWNTO 0) WHEN addr2_mux = "01" AND ir_reg(5) = '1' ELSE
					"0000000" & ir_reg(8 DOWNTO 0) WHEN addr2_mux = "10" AND ir_reg(8) = '0' ELSE
					"1111111" & ir_reg(8 DOWNTO 0) WHEN addr2_mux = "10" AND ir_reg(8) = '1' ELSE
					"00000" & ir_reg(10 DOWNTO 0) WHEN addr2_mux = "11" AND ir_reg(10) = '0' ELSE
					"11111" & ir_reg(10 DOWNTO 0);
	
	-- marmux
	marmux <= add WHEN mar_mux = '0' ELSE 
				 "00000000" & ir_reg(7 DOWNTO 0);
	
	-- read_addr
	addr_ram <= TO_INTEGER(UNSIGNED(datapath));
	
	-- mioen
	mioen <= inmux WHEN mio_en = '0' ELSE datapath;
	
	-- inmux
	WITH in_mux SELECT
		inmux <= kbdr_reg WHEN "00",
					kbsr_reg WHEN "01",
					dsr_reg WHEN "10",
					ram_out WHEN OTHERS;
					
	
	-- CONTROL LOGIC FOR MEMORY-MAPPED I/O
	
	logic_control <= "0XX000" WHEN mio_en = '0' ELSE
						  "001000" WHEN mar_reg = x"FE00" AND mio_en = '1' AND r_w = '0' ELSE
						  "011100" WHEN mar_reg = x"FE00" AND mio_en = '1' AND r_w = '1' ELSE
						  "000000" WHEN mar_reg = x"FE02" AND mio_en = '1' AND r_w = '0' ELSE
						  "011000" WHEN mar_reg = x"FE02" AND mio_en = '1' AND r_w = '1' ELSE
						  "010000" WHEN mar_reg = x"FE04" AND mio_en = '1' AND r_w = '0' ELSE
						  "011010" WHEN mar_reg = x"FE04" AND mio_en = '1' AND r_w = '1' ELSE
						  "011000" WHEN mar_reg = x"FE06" AND mio_en = '1' AND r_w = '0' ELSE
						  "011001" WHEN mar_reg = x"FE06" AND mio_en = '1' AND r_w = '1' ELSE
						  "111000" WHEN mio_en = '1' AND r_w = '0' ELSE
						  "1XX001";
	
	mem_en <= logic_control(5);
	in_mux <= logic_control(4 DOWNTO 3);
	ld_kbsr <= logic_control(2);
	ld_dsr <= logic_control(1);
	ld_ddr <= logic_control(0);
	
	-- CONTROL PATH : STATE REGISTER
		PROCESS(clk, reset)
		BEGIN
			IF reset='1' THEN
				state_reg <= e18;
			ELSIF(clk'EVENT AND clk='1') THEN
				state_reg <= state_next;
			END IF;
		END PROCESS;
	
		-- DATA PATH : DATA REGISTER
		PROCESS(clk, reset)
		BEGIN
			IF reset='1' THEN
				mar_reg <= (OTHERS => '0');
				mdr_reg <= (OTHERS => '0');
				ir_reg <= (OTHERS => '0');
				--pc_reg <= (OTHERS => '0');
				--pc_reg <= "0000000000010000";
				pc_reg <= x"3000";
				ben_reg <= '0';
				kbdr_reg <= (OTHERS => '0');
				kbsr_reg <= (OTHERS => '0');
				dsr_reg <= (OTHERS => '0');
				ddr_reg <= (OTHERS => '0');
			ELSIF(clk'EVENT AND clk='1') THEN
				mar_reg <= mar_next;
				mdr_reg <= mdr_next;
				ir_reg <= ir_next;
				pc_reg <= pc_next;
				ben_reg <= ben_next;
				kbdr_reg <= kbdr_next;
				kbsr_reg <= kbsr_next;
				dsr_reg <= dsr_next;
				ddr_reg <= ddr_next;
			END IF;
		END PROCESS;
		
		-- NEXT-STATE LOGIC DATA REGISTER
		mar_next <= datapath WHEN ld_mar = '1' ELSE mar_reg;
		mdr_next <= mioen WHEN ld_mdr = '1' ELSE mdr_reg;
		ir_next <= datapath WHEN ld_ir = '1' ELSE ir_reg;
		pc_next <= pcmux WHEN ld_pc = '1' ELSE pc_reg;
		ben_next <= ben WHEN ld_ben = '1' ELSE ben_reg;
		kbdr_next <= data_in;
		kbsr_next <= mdr_reg when ld_kbsr = '1' ELSE kbsr_reg;
		dsr_next <= mdr_reg when ld_dsr = '1' ELSE dsr_reg;
		ddr_next <= mdr_reg when ld_ddr = '1' ELSE ddr_reg;
		
		-- datapath GATES
		datapath <= marmux WHEN gate_mar_mux = '1'  AND gate_pc = '0' AND gate_alu = '0' AND gate_mdr = '0'  ELSE
						pc_reg WHEN  gate_mar_mux = '0' AND gate_pc = '1' AND gate_alu = '0' AND gate_mdr = '0'  ELSE
						alu_out WHEN gate_mar_mux = '0' AND gate_pc = '0' AND gate_alu = '1' AND gate_mdr = '0'  ELSE
						mdr_reg;
		
		--CONTROL & DATA PATH : NEXT-STATE & OUTPUT LOGICc
		PROCESS(state_reg, ir_reg, ben)
					
		BEGIN
			CASE state_reg IS
				WHEN e18 =>
				
					state_next <= e33;
						
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					ld_pc <= '1';
					
					gate_pc <= '1';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e33 =>
				
					state_next <= e35;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '1';
					ld_ir <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					ld_pc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e35 =>
				
					state_next <= e32;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '1';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					ld_pc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '1';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e32 =>
					
					IF(ir_reg(15 DOWNTO 12)="0001") THEN -- ADD
						state_next <= e1;
					ELSIF(ir_reg(15 DOWNTO 12)="0101") THEN -- AND
						state_next <= e5;
					ELSIF(ir_reg(15 DOWNTO 12)="1001") THEN -- NOT
						state_next <= e9;
					ELSIF(ir_reg(15 DOWNTO 12)="1111") THEN -- TRAP
						state_next <= e15;
					ELSIF(ir_reg(15 DOWNTO 12)="1110") THEN -- LEA
						state_next <= e14;
					ELSIF(ir_reg(15 DOWNTO 12)="0010") THEN -- LD
						state_next <= e2;
					ELSIF(ir_reg(15 DOWNTO 12)="0110") THEN -- LDR
						state_next <= e6;
					ELSIF(ir_reg(15 DOWNTO 12)="1010") THEN -- LDI
						state_next <= e10;
					ELSIF(ir_reg(15 DOWNTO 12)="1011") THEN -- STI
						state_next <= e11;
					ELSIF(ir_reg(15 DOWNTO 12)="0111") THEN -- STR
						state_next <= e7;
					ELSIF(ir_reg(15 DOWNTO 12)="0011") THEN -- ST
						state_next <= e3;
					ELSIF(ir_reg(15 DOWNTO 12)="0100") THEN -- JSR
						state_next <= e4;
					ELSIF(ir_reg(15 DOWNTO 12)="1100") THEN -- JMP
						state_next <= e12;
					ELSIF(ir_reg(15 DOWNTO 12)="0000") THEN -- BR
						state_next <= e0;
					ELSE -- default RTI and others
						state_next <= e18;	
					END IF;

					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '1';
					ld_reg <= '0';
					ld_cc <= '1';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
				
				WHEN e1 => -- ADD
				
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '1';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '1';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					IF(ir_reg(5) = '0') THEN
						sr2_mux <= '0';
					ELSE
						sr2_mux <= '1';
					END IF;
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "01";
					addr2_mux <= "00";
					aluk <= "00";
				
				WHEN e5 => -- AND
					
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '1';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '1';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					IF(ir_reg(5) = '0') THEN
						sr2_mux <= '0';
					ELSE
						sr2_mux <= '1';
					END IF;
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "01";
					addr2_mux <= "00";
					aluk <= "11";
					
				WHEN e9 => -- NOT
				
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '1';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '1';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "01";
					addr2_mux <= "00";
					aluk <= "01";
					
				WHEN e15 => -- TRAP_1
					
					state_next <= e28;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '0';
					mar_mux <= '1';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e28 => -- TRAP_2
					
					state_next <= e30;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '1';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '0';
					
					gate_pc <= '1';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "11";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
				
				WHEN e30 => -- TRAP_3
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '1';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '1';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "10";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e14 =>  -- LEA
				
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '1';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "10";
					aluk <= "00";
					
				WHEN e2 => -- LD
				
					state_next <= e25;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "10";
					aluk <= "00";
					
				WHEN e25 => -- LD*_2
					
					state_next <= e27;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '1';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e27 => -- LD*_3
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '1';
					
					gate_pc <= '0';
					gate_mdr <= '1';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e6 => -- LDR
				
					state_next <= e25;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '1';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "01";
					addr2_mux <= "01";
					aluk <= "00";
					
				WHEN e10 => -- LDI_1
					state_next <= e24;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "10";
					aluk <= "00";
					
				WHEN e24 => -- LDI_2
					
					state_next <= e26;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '1';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e26 => -- LDI_3
				
					state_next <= e25;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '1';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e11 => -- STI_1
				
					state_next <= e29;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "10";
					aluk <= "00";
					
				WHEN e29 => -- STI_2
					
					state_next <= e31;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '1';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e31 => -- STI_3
				
					state_next <= e23;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '1';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e23 => -- ST*_1
				
					state_next <= e16;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '1';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '1';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "10";
					
				WHEN e16 => -- ST*_2
					
					state_next <= e18;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '1';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e7 => -- STR
				
					state_next <= e23;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '1';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "01";
					addr2_mux <= "01";
					aluk <= "00";
					
				WHEN e3 => -- ST
				
					state_next <= e23;
					
					-- routing
					ld_mar <= '1';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '1';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '1';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "10";
					aluk <= "00";
					
				WHEN e4 => -- ISR
				
					IF(ir_reg(11)='1') THEN
						state_next <= e21;
					ELSE
						state_next <= e20;
					END IF;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					ld_pc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
				
				WHEN e21 => -- ISR_a
				
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '1';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '0';
					
					gate_pc <= '1';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "01";
					dr_mux <= "11";
					sr1_mux <= "00";
					addr2_mux <= "11";
					aluk <= "00";					
					
				WHEN e20 => -- ISR_b
				
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '1';
					ld_ben <= '0';
					ld_reg <= '1';
					ld_cc <= '0';
					
					gate_pc <= '1';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '1';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "01";
					dr_mux <= "11";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e12 => --JMP
				
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '1';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '1';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "01";
					dr_mux <= "00";
					sr1_mux <= "01";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e0 => -- BR_1
				
					IF(ben = '1') THEN
						state_next <= e22;
					ELSE
						state_next <= e18;
					END IF;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					ld_pc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "00";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "00";
					aluk <= "00";
					
				WHEN e22 => -- BR_2
				
					state_next <= e18;
					
					-- routing
					ld_mar <= '0';
					ld_mdr <= '0';
					ld_ir <= '0';
					ld_pc <= '1';
					ld_ben <= '0';
					ld_reg <= '0';
					ld_cc <= '0';
					
					gate_pc <= '0';
					gate_mdr <= '0';
					gate_alu <= '0';
					gate_mar_mux <= '0';
					
					addr1_mux <= '0';
					mar_mux <= '0';
					mio_en <= '0';
					r_w <= '0';
					sr2_mux <= '0';
					
					pc_mux <= "01";
					dr_mux <= "00";
					sr1_mux <= "00";
					addr2_mux <= "10";
					aluk <= "00";
					
			END CASE;
		END PROCESS;
END behavioral;