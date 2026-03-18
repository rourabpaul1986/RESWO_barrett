----------------------------------------------------------------------------------
-- Company: 
-- Engineer: rourab paul
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

entity RESO_c_shifter_1bit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           Aw : in STD_LOGIC_VECTOR (w-1 downto 0);
           Bw : in STD_LOGIC_VECTOR (w-1 downto 0);
           idx_a : in integer range 0 to l/w-1 := 0;
           idx_b : in integer range 0 to l/w-1 := 0;
           c_shift : out STD_LOGIC_VECTOR (2*logq-1 downto 0);
           c : out  std_logic_vector((2*w + ((l/w-1 + l/w-1)*w))-1 downto 0);
           done : out STD_LOGIC
           );
end RESO_c_shifter_1bit;

architecture Behavioral of RESO_c_shifter_1bit is
constant k : integer := 2*logq; --32 for w=4
constant mu : integer := (2**(2*logq)) / q; --2^k//n
signal C_shift_buf :  std_logic_vector((2*w + ((l/w-1 + l/w-1)*w)+2 + k)-1 downto 0) := (others => '0'); 
attribute use_dsp : string;
attribute use_dsp of C_shift_buf : signal is "yes";
signal done_buf : std_logic; 
signal zero_pad : std_logic_vector(k-1 downto 0) := (others => '0'); -- No change
-- signal Q : std_logic_vector((2*w + ((l/w-1 + l/w-1)*w))-1 downto 0) := (others => '0'); -- 24
  signal delta : integer range 0 to 2**w-1:=7; -- Adjusted range to allow for negative values
  signal i1 : integer range 0 to w-1 := 3; -- Optimized for loop index
signal j1 : integer range 0 to w-1 := 0; -- Optimized for loop index
signal  Q2 : std_logic_vector((2*w + ((l/w-1 + l/w-1)*w))-1+2 downto 0) := (others => '0'); -- 24
begin
-- delta <= 2**i1-2**j1 when Aw(i1)='1' and Aw(j1)='0' else
--          2**j1-2**i1 when Aw(i1)='0' and Aw(j1)='1' else
--          0;

 -- Next state logic
    process(start, clk, rst)  
     variable  Q1 : std_logic_vector((2*w + ((l/w-1 + l/w-1)*w))-1+2 downto 0) := (others => '0'); -- 24
     variable m : std_logic_vector(2*w-1+2 downto 0) := (others => '0'); -- Optimized bit-width
     

    --attribute use_dsp : string;
    --attribute use_dsp of m : variable is "yes";

     variable Aw_sig :  STD_LOGIC_VECTOR (w-1+1 downto 0);  
     variable Bw_sig :  STD_LOGIC_VECTOR (w-1+1 downto 0); 
    begin
    
         if rst = '1' then
            C_shift_buf<=(others => '0');
            done_buf<='0';
         elsif rising_edge(clk) then
                if start = '1' then
                 Aw_sig:=Aw & '0';
                 Bw_sig:=Bw & '0';
                 --m := std_logic_vector(to_unsigned((to_integer(unsigned(Aw_sig)) * to_integer(unsigned(Bw_sig))), 2*w+2));
                 m :=std_logic_vector(resize(unsigned(Aw_sig), w+1) *  resize(unsigned(Bw_sig), w+1));
                 
                 if(idx_a=0 and idx_b=0) then
                    q1(q1'length - 1 downto 2*w+2)  :=(others=>'0');  
                    Q1(2*w-1+2 downto 0):=std_logic_vector(to_unsigned((to_integer(unsigned(m))), 2*w+2));
                 elsif(q1'length /= 2*w+(idx_a+idx_b)*w) then 
                    q1(q1'length - 1 downto 2*w+(idx_a+idx_b)*w-2)  :=(others=>'0');                
                    Q1(2*w+(idx_a+idx_b)*w-1+2 downto 0):=std_logic_vector(to_unsigned((to_integer(unsigned(m))), 2*w+2)) & zero_pad((idx_a+idx_b)*w-1 downto 0);                   
                 else
                    Q1(2*w+(idx_a+idx_b)*w-1+2 downto 0):=std_logic_vector(to_unsigned((to_integer(unsigned(m)) ), 2*w+2)) & zero_pad((idx_a+idx_b)*w-1 downto 0);                   
                 end if;
                --C_shift_buf<=std_logic_vector(unsigned(Q1)* to_unsigned(mu, k));
                C_shift_buf<=std_logic_vector(unsigned(Q1)* mu_vec);
                done_buf<='1';
                c<=q1(q1'length-1 downto 2);
                Q2<=Q1;
                end if;
         end if;
     end process;       
c_shift<=c_shift_buf(C_shift_buf'length-1 downto C_shift_buf'length - k);
--c<=c_var;
--c:=q;
done<=done_buf;
end Behavioral;
