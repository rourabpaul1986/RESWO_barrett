----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 12:44:23 PM
-- Design Name: 
-- Module Name: barrett_pipe - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conv_barrett_pipe is
    Port (
        clk : in std_logic;                   -- Clock input
        reset : in std_logic;                 -- Reset input
        start : in std_logic;                 -- Start signal for multiplication
        A : in std_logic_vector(logq-1 downto 0);-- Operand A
        B : in std_logic_vector(logq-1 downto 0);-- Operand B
        done : out std_logic; -- Output T
        fault : out std_logic; -- Output T
        T : out std_logic_vector(logq-1 downto 0) -- Output T
    );
end conv_barrett_pipe;

architecture Behavioral of conv_barrett_pipe is
 signal  c_shift :  STD_LOGIC_VECTOR (2*logq-1 downto 0);
 signal        c : STD_LOGIC_VECTOR (2*logq-1 downto 0);
 signal cshift_done : std_logic; 
begin
     c_shift_DUT: entity work.conv_c_shifter
        port map (
            clk => clk,
            rst => reset,
            start => start,
            a =>A,
            b =>B,
            c_shift =>c_shift,
            c =>c,
           done =>cshift_done
        ); 
        
         R_come_DUT: entity work. conv_r_com
        port map (
            clk => clk,
            rst => reset,
            start => cshift_done,
            c_shift =>c_shift,
            c =>c,
            T =>T,
           done =>done
        ); 

end Behavioral;