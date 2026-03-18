----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 11:57:03 AM
-- Design Name: 
-- Module Name: r_come - Behavioral
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


entity conv_r_com is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           c : in STD_LOGIC_VECTOR (2*logq-1 downto 0);
           c_shift : in STD_LOGIC_VECTOR (2*logq-1 downto 0);
           T : out STD_LOGIC_VECTOR (logq-1 downto 0);
           done : out STD_LOGIC
           );
end conv_r_com;

architecture Behavioral of conv_r_com is
signal done_buf : std_logic; 
signal  T_reg1 : std_logic_vector(logq downto 0) := (others => '0'); 
constant mu : integer := (2**(2*logq)) / q; --2^k//n
constant k : integer := 2*logq; --32 for w=4
--signal R : std_logic_vector(logq downto 0) := (others => '0');
begin
    process(start, clk, rst)   
       variable  T_reg : std_logic_vector(logq downto 0) := (others => '0');   
       variable R2 : std_logic_vector(logq downto 0) := (others => '0');
    begin
    
         if rst = '1' then
            
            done_buf<='0';
         elsif rising_edge(clk) then
               
                if start = '1' then
                   T_reg:=(others => '0');
                   done_buf<='1';
                  R2 :=  std_logic_vector(
                  to_unsigned(
                  (to_integer(unsigned(c)) - to_integer(unsigned(c_shift)*q)), logq+1)
                  --(to_integer(unsigned(c)) - to_integer((unsigned(c)*mu*q)(2*logq-1 downto logq))), logq)
                    );
--                  R <=  std_logic_vector(
--                  to_unsigned(
--                  (to_integer(unsigned(c)) - to_integer(unsigned(c_shift)*q)), logq+1)
--                  --(to_integer(unsigned(c)) - to_integer((unsigned(c)*mu*q)(2*logq-1 downto logq))), logq)
--                    );
                     
                  if unsigned(R2) >= to_unsigned(q, T_reg'length) then                 
                   T_reg:= std_logic_vector(resize(unsigned(T_reg)+unsigned(R2) - to_unsigned(q, logq) , logq+1));
                  --T_reg <= std_logic_vector(resize(unsigned(T_reg) + resize(unsigned(R2), T_reg'length) - resize(to_unsigned(N, R1'length), T_reg'length), T_reg'length));

                 else
                   T_reg:= std_logic_vector(resize(unsigned(T_reg)+unsigned(R2), logq+1));
                 end if;

                 if unsigned(T_reg) >= to_unsigned(q, T_reg'length) then                 
                   T_reg1<= std_logic_vector(resize(unsigned(T_reg) - to_unsigned(q, logq) , logq+1));
                 else
                   T_reg1<= std_logic_vector(resize(unsigned(T_reg), logq+1));
                 end if;
                end if;
          end if;
     end process; 
     
T<=T_reg1(logq-1 downto 0);
done<=done_buf;
end Behavioral;