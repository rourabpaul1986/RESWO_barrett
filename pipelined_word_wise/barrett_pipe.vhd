----------------------------------------------------------------------------------
-- Company: Personal
-- Engineer: Rourab Paul
-- 
-- Create Date: 04/11/2025 12:44:23 PM
-- Design Name: word wise barret modular reudction
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

entity barrett_pipe is
    Port (
        clk : in std_logic;                   -- Clock input
        reset : in std_logic;                 -- Reset input
        start : in std_logic;                 -- Start signal for multiplication
        A : in std_logic_vector(logq-1 downto 0);-- Operand A
        B : in std_logic_vector(logq-1 downto 0);-- Operand B
        done : out std_logic; -- Output T
       -- fault : out std_logic; -- Output T
        T : out std_logic_vector(logq-1 downto 0) -- Output T
    );
end barrett_pipe;

architecture Behavioral of barrett_pipe is
 signal  c_shift :  STD_LOGIC_VECTOR (2*logq-1 downto 0);
 signal        c :  std_logic_vector((2*w + ((l/w-1 + l/w-1)*w))-1 downto 0);
 signal cshift_done : std_logic; 
  signal done_rcom : std_logic; 
 constant NUM_SLICES : integer := l / w;
    signal idx_b : integer range 0 to NUM_SLICES-1 := 0;
    signal idx_a : integer range 0 to NUM_SLICES-1 := 0;
    signal idx_b_d, idx_b_dd,  idx_b_ddd : integer range 0 to NUM_SLICES-1 := 0;
    signal idx_a_d, idx_a_dd, idx_a_ddd : integer range 0 to NUM_SLICES-1 := 0;
    signal      Aw :  std_logic_vector(w-1 downto 0);-- Operand A
     signal    Bw :  std_logic_vector(w-1 downto 0);-- Operand B
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                idx_b <= 0;
                idx_a <= 0;
                Aw    <= (others => '0');
                Bw    <= (others => '0');
            elsif (start='1') then
                -- output slices
                Aw <= A((idx_a_d*W+(W-1)) downto idx_a_d*W);
                Bw <= B((idx_b_d*W+(W-1)) downto idx_b_d*W);
                idx_a_d<=idx_a;
                idx_b_d<=idx_b;
                idx_a_dd<=idx_a_d;
                idx_b_dd<=idx_b_d;
                idx_a_ddd<=idx_a_dd;
                idx_b_ddd<=idx_b_dd;
                
                if idx_a_ddd=NUM_SLICES-1 and idx_b_ddd=NUM_SLICES-1 then
                   done<='1';
                else
                   done<='0';
                end if;
                -- advance B slice every clock
                if idx_b = NUM_SLICES-1 then
                    idx_b <= 0;

                    -- advance A slice only after B completes
                    if idx_a = NUM_SLICES-1 then
                        idx_a <= 0;       -- wrap (or stop here)
                    else
                        idx_a <= idx_a + 1;
                    end if;
                else
                    idx_b <= idx_b + 1;
                end if;
            end if;
        end if;
    end process;

     stage_1: entity work.c_shifter
        port map (
            clk => clk,
            rst => reset,
            start => start,
            a =>Aw,
            b =>Bw,
            idx_a=>idx_a_dd,
            idx_b=>idx_b_dd,
            c_shift =>c_shift,
            c =>c,
           done =>cshift_done
        ); 
        
         stage_2: entity work.r_com
        port map (
            clk => clk,
            rst => reset,
            start => cshift_done,
            c_shift =>c_shift,
            c =>c,
            T =>T,
           done =>done_rcom
        ); 

end Behavioral;