LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY cond_cod IS
	PORT(
		clk, reset, ld_cc : IN std_logic;
		data : IN std_logic_vector(15 DOWNTO 0);
		ir : IN std_logic_vector(11 DOWNTO 9);
		n, z, p, ben : OUT std_logic
	);
END cond_cod;

ARCHITECTURE behavioral OF cond_cod IS

	SIGNAL n_next, n_reg, n_value : std_logic;
	SIGNAL z_next, z_reg, p_value : std_logic;
	SIGNAL p_next, p_reg, z_value : std_logic;

	BEGIN

		PROCESS(clk, reset)
		BEGIN
			IF reset='1' THEN
				n_reg <= '0';
				z_reg <= '0';
				p_reg <= '0';
			ELSIF(clk'EVENT AND clk='1') THEN
				n_reg <= n_next;
				z_reg <= z_next;
				p_reg <= p_next;
			END IF;
		END PROCESS;

		PROCESS(data)
			BEGIN
			IF(data(15) = '1') THEN
				n_value <= '1';
				z_value <= '0';
				p_value <= '0';
			ELSIF(data=x"0000") THEN
				n_value <= '0';
				z_value <= '1';
				p_value <= '0';
			ELSE
				n_value <= '0';
				z_value <= '0';
				p_value <= '1';
			END IF;
		END PROCESS;
		
		-- NEXT-STATE LOGIC
		n_next <= n_value when ld_cc='1' else n_reg;
		z_next <= z_value when ld_cc='1' else z_reg;
		p_next <= p_value when ld_cc='1' else p_reg;
					 
		-- OUTPUT LOGIC
		n <= n_reg;
		z <= z_reg;
		p <= p_reg;
		
		-- ben
		ben <= (ir(11) and n_reg) or (ir(10) and z_reg) or (ir(9) and p_reg);
		
END behavioral;