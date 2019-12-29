library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port(
		ALUK : in std_logic_vector(1 downto 0);
		A, B : in std_logic_vector(15 downto 0);
		Y : out std_logic_vector(15 downto 0)
		);
end alu;

architecture behavorial of alu is
	signal sum, ayb, not_a : std_logic_vector(15 downto 0);
	
	begin
		sum <= std_logic_vector(signed(A) + signed(B));
		ayb <= A and B;
		not_a <= not A;
		
		Y <= sum when ALUK = "00" else
			  not_a when ALUK = "01" else
			  A when ALUK = "10" else
			  ayb;
			  
 end behavorial;