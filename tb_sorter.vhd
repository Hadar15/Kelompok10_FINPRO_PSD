library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_sorter is
end tb_sorter;

architecture Behavioral of tb_sorter is

    -- Component declaration for Unit Under Test (UUT)
    component top_sorter is
        Port (
            i_clk         : in  std_logic;
            i_rst         : in  std_logic;
            i_start       : in  std_logic;
            i_raw_data    : in  t_data_array;
            o_sorted_data : out t_data_array;
            o_done        : out std_logic
        );
    end component;
    
    constant CLK_PERIOD : time := 10 ns;

begin
end Behavioral;