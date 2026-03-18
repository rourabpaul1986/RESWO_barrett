library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fault_RENO is
    generic (
        L : integer := 20;        -- Length of the operands
        w : integer := 4;        -- Length of the operands
        S : integer := 40;        -- Length of the operands
        k : integer := 40;         -- Width of the segments
        N : integer := 72639;
        mu : integer := 15136656     -- The modulus    
    );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           Aw,Bw : in STD_LOGIC_VECTOR (w-1 downto 0);
            i, j : in natural range 0 to l/w-1 := 0; 
           done : out STD_LOGIC;
           R : out STD_LOGIC_VECTOR (L-1 downto 0)
           );
end fault_RENO;

architecture fault_RENO_arch of fault_RENO is
 type state_type is (IDLE, BUFFER_Aw, SWAP, SHIFT,CxMU_COM, FINALIZE);
  signal state : state_type;
--constant Xk : std_logic_vector(2*S-1 downto 0) := x"00000000000000000005";
--signal QN : std_logic_vector(2*s-1 downto 0);
--signal R_t : std_logic_vector(2*s-1 downto 0);
signal C_shift : std_logic_vector(s-1 downto 0) := (others => '0');
signal zero_pad : std_logic_vector(w*(l/w-1 + l/w-1)-1 downto 0) := (others => '0');
signal Q : std_logic_vector((s + k)-1 downto 0) := (others => '0'); 
signal R2 : std_logic_vector(L-1 downto 0) := (others => '0');
signal done_reg : std_logic;

signal i1 : integer range 0 to w-1 := 3; -- Optimized for loop index
signal j1 : integer range 0 to w-1 := 0; -- Optimized for loop index
signal delta : integer range -2**w to 2**w-1; -- Adjusted range to allow for negative values
begin



process(state, start, reset, clk)  
variable Aw_sig,Bw_sig :  STD_LOGIC_VECTOR (w-1 downto 0);   
    begin
    
         if reset = '1' then
            state <= IDLE;
            done_reg<='0';           

        elsif start='0' then
            state <= IDLE;
        elsif rising_edge(clk) then
        case state is
            when IDLE =>
              if start = '1' then
                 done_reg<='0';
                Aw_sig := STD_LOGIC_VECTOR(UNSIGNED(NOT Aw) + 1);
                 Bw_sig:= Bw;
 

                    state <= BUFFER_Aw;
              else
                    state <= IDLE;     
              end if;
                        
            
            when BUFFER_Aw =>   
                if(i=0 and j=0) then --c_shift = aw*bw << (i + j) * w  #c_shift
                    C_shift(2*w-1 downto 0)<=std_logic_vector(to_unsigned((to_integer(unsigned(Aw_sig)) * to_integer(unsigned(Bw_sig))), 2*w));
                 else
                    C_shift(s-1 downto 2*w+(i+j)*w)<=(others => '0');
                    C_shift(2*w+(i+j)*w-1 downto 0)<=std_logic_vector(to_unsigned((to_integer(unsigned(Aw_sig)) * to_integer(unsigned(Bw_sig))), 2*w)) & zero_pad((i+j)*w-1 downto 0);
                  end if; 
                  state <= SWAP;
                  
             when SWAP=>  
                  --       Q <= std_logic_vector(resize(unsigned(C_shift) * to_unsigned(mu, C_shift'length), Q'length)); --c_shift*mu                                     
                  R2 <=  std_logic_vector(resize(unsigned(C_shift)-unsigned(std_logic_vector(resize(unsigned(resize(unsigned(C_shift) * to_unsigned(mu, C_shift'length), Q'length)(2*s-1 downto k)) * to_unsigned(N, L), L))),L));

                 state <= SHIFT;
                 
                  
             when SHIFT=>   
                           
                 
                  state <= FINALIZE;
                 
              when CxMU_COM=>                            
  
             
              when FINALIZE =>               
                state <= FINALIZE;  -- stay inside it
                done_reg<='1';
            
        end case;
        end if;
     end process;


done <= done_reg;
R <= STD_LOGIC_VECTOR(UNSIGNED(NOT R2) + 1);


end fault_RENO_arch;
