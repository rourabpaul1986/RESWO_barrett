----------------------------------------------------------------------------------
-- Testbench for Barrett Reduction
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.variant_pkg.all;
use IEEE.MATH_REAL.ALL;
use std.env.all;
entity tb_barrett_pipe is
    generic (
        L : integer := logq;
        w : integer := logq;
        N : integer := q
    );
end tb_barrett_pipe;

architecture Behavioral of tb_barrett_pipe is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal start : std_logic := '0';

    signal A, B  : std_logic_vector(L-1 downto 0);
    signal T     : std_logic_vector(L-1 downto 0);

    signal done  : std_logic := '0';
    signal fault : std_logic := '0';

    constant clk_period : time := 10 ns;
    constant logN : positive := positive(ceil(log2(real(N))));

    signal seed1 : positive := 1357;
    signal seed2 : positive := 2468;
    signal rand_real : real;

begin



    uut : entity work.barrett_pipe_protected_RESWO
        port map (
            clk   => clk,
            reset => reset,
            start => start,
            A     => A,
            B     => B,
            T     => T,
            done  => done,
            fault => fault 
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    stimulus : process
    begin
        reset <= '1';
        start <= '0';
        wait for clk_period;

        reset <= '0';
        start <= '1';

        wait;
    end process;

random_inputs : process(clk)
    variable seed1     : positive := 1357;
    variable seed2     : positive := 2468;
    variable rand_real : real;
    variable rand_int  : integer;
begin
    if rising_edge(clk) then
        if reset = '1' then
            A <= (others => '0');
            B <= (others => '0');
        elsif start = '1' then
--            uniform(seed1, seed2, rand_real);
--            rand_int := integer(rand_real * real(2**L));
--            A <= conv_std_logic_vector(rand_int, L);

--            uniform(seed1, seed2, rand_real);
--            rand_int := integer(rand_real * real(2**L));
--            B <= conv_std_logic_vector(rand_int, L);
        A <= conv_std_logic_vector(2792, L);     -- A = 2792
        B <= conv_std_logic_vector(1129, L);     -- B = 1229

        end if;
    end if;
end process;

stop_sim : process(clk)
begin
    if rising_edge(clk) then
        if done = '1' then
            report "Simulation finished: done asserted" severity note;
            stop;   -- cleanly stops simulation
        end if;
    end if;
end process;

end Behavioral;
