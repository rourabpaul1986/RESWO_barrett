----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 09:01:00 AM
-- Design Name: 
-- Module Name: c_shifter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.variant_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conv_c_shifter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (logq-1 downto 0);
           b : in STD_LOGIC_VECTOR (logq-1 downto 0);
           c_shift : out STD_LOGIC_VECTOR (2*logq-1 downto 0);
           c : out STD_LOGIC_VECTOR (2*logq-1 downto 0);
           done : out STD_LOGIC
           );
end conv_c_shifter;

architecture Behavioral of conv_c_shifter is
constant k : integer := 2*logq; --32 for w=4
constant mu : integer := (2**(2*logq)) / q; --2^k//n
signal C_shift_buf : std_logic_vector(2*k-1 downto 0) := (others => '0'); -- Optimized bit-width
signal done_buf : std_logic; 


begin
 -- Next state logic
    process(start, clk, rst)  
     
    begin
    
         if rst = '1' then
            C_shift_buf<=(others => '0');
            done_buf<='0';
         elsif rising_edge(clk) then
                if start = '1' then
                c<=std_logic_vector(unsigned(a) * unsigned(b));
                --C_shift_buf<=std_logic_vector(unsigned(a)*unsigned(b)* to_unsigned(mu, k));
                C_shift_buf<=std_logic_vector(unsigned(unsigned(a)*unsigned(b))* mu_vec);
                done_buf<='1';
                end if;
         end if;
     end process;       
c_shift<=c_shift_buf(2*k-1 downto k);
--c<=c_var;
done<=done_buf;
end Behavioral;