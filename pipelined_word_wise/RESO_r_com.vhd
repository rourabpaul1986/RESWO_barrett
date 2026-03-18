----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 11:57:03 AM
-- Design Name: 
-- Module Name: r_com - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.variant_pkg.all;


entity RESO_r_com is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           c : in  std_logic_vector((2*w + ((l/w-1 + l/w-1)*w))-1 downto 0);
           c_shift : in STD_LOGIC_VECTOR (2*logq-1 downto 0);
           R : out STD_LOGIC_VECTOR (logq downto 0);
           done : out STD_LOGIC
           );
end RESO_r_com;

architecture Behavioral of RESO_r_com is
signal done_buf : std_logic; 
signal  T_reg1 : std_logic_vector(logq downto 0) := (others => '0'); 
constant mu : integer := (2**(2*logq)) / q; --2^k//n
constant k : integer := 2*logq; --32 for w=4
signal result : std_logic_vector(logq-1 downto 0) := (others => '0');
signal R2 : std_logic_vector(logq downto 0) := (others => '0');
begin
    process(start, clk, rst)   

    begin
    
         if rst = '1' then
            
            done_buf<='0';
         elsif rising_edge(clk) then
               
                if start = '1' then
          
                   done_buf<='1';
                  R2 <=  std_logic_vector(
                  to_unsigned(
                  (to_integer(unsigned(c)) - to_integer(unsigned(c_shift)*q)), logq+1)
                  --(to_integer(unsigned(c)) - to_integer((unsigned(c)*mu*q)(2*logq-1 downto logq))), logq)
                    );

                end if;
          end if;
     end process; 
     
R<=R2;
done<=done_buf;
end Behavioral;
