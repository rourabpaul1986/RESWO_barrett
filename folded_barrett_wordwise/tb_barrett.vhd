----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2025 03:00:07 PM
-- Design Name: 
-- Module Name: tb_barrett - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.math_real.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_barrett is
    generic (
        L : integer := 20;        -- Length of the operands
        w : integer := 20;         -- Width of the segments
        N : integer := 72639    -- The modulus       
        
    );
end tb_barrett;

architecture Behavioral of tb_barrett is
    -- Generic parameter L for bit width

    -- Signals for the testbench
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal start : std_logic := '0';
    signal A, B: std_logic_vector(L-1 downto 0);
    signal T : std_logic_vector(L-1 downto 0);
     signal done : std_logic := '0';
     signal fault : std_logic := '0';
     constant logN : positive := positive(ceil(log2(real(N))));
    -- Clock generation process
    constant clk_period : time := 10 ns;
begin
    assert logN < L
    report "Error:The number of bit required to store N is greater than or equal to L. Please adjust the parameters."
    severity FAILURE; 
  -- Instantiate the montgomery_mult module with L as a generic
    uut: entity work.barrett_top
        generic map (
            L => L,
            w=>w,
            N=>N
        )
        port map (
            clk => clk,
            reset => reset,
            start => start,
            A => A,
            B => B,
            done => done,
            fault => fault,
            T => T
        );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process
    stimulus : process
    begin
        -- Initialize inputs
        reset <= '1';
        start <= '0';
        wait for clk_period;

        reset <= '0';
        start <= '1';
        A <= conv_std_logic_vector(5792, L);     -- A = 5792
        B <= conv_std_logic_vector(1229, L);     -- B = 1229
        
        -- Allow time for calculations
        wait for 10 * clk_period;

        -- Check output T
       
        -- Stop simulation
        wait;
    end process;
end Behavioral;
