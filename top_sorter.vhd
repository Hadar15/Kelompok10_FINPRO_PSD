library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.sorter_pkg.all;    

entity top_sorter is
    Port (
        i_clk         : in  std_logic;                    -- Clock input
        i_rst         : in  std_logic;                    -- Reset (Active High)
        i_start       : in  std_logic;                    -- Start signal
        i_raw_data    : in  t_data_array;                 -- Input: unsorted data
        o_sorted_data : out t_data_array;                 -- Output: sorted data
        o_done        : out std_logic                     -- Done flag
    );
end top_sorter;

architecture Behavioral of top_sorter is
    -- Internal signals placeholders
    signal reg_input_data  : t_data_array;
    signal reg_output_data : t_data_array;

    -- MODUL 5: Component declaration for structural programming
    component bitonic_net is
        Port (
            i_data : in  t_data_array;
            o_data : out t_data_array
        );
    end component;
    
    signal net_output      : t_data_array;

begin

    -- MODUL 5: Structural MOdel
    bitonic_inst: bitonic_net
        port map (
            i_data => reg_input_data,
            o_data => net_output
        );
    
        

end Behavioral;