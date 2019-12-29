LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ram IS
    PORT (
        clk : IN STD_LOGIC;
        r_w, mem_en : IN STD_LOGIC;
        ram_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        addr_ram : IN INTEGER RANGE 0 TO 65535;
        ram_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END ENTITY ram;

ARCHITECTURE ram_arch OF ram IS

	TYPE memory IS ARRAY (65535 DOWNTO 0) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL content: memory;  

--	ATTRIBUTE ram_init_file : STRING;
--	ATTRIBUTE ram_init_file OF CONTENT:
--	SIGNAL IS "sum.mif";
		
	BEGIN
		
		 PROCESS(clk, mem_en)
		 
		 BEGIN
			IF (RISING_EDGE(clk) AND mem_en = '1') THEN
				CASE r_w IS
					WHEN '1' => content(addr_ram) <= ram_in;
					WHEN OTHERS => ram_out <= content(addr_ram);
				END CASE;
		  END IF;
		 END PROCESS;
END ARCHITECTURE;