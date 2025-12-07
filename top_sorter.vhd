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
begin
end Behavioral;