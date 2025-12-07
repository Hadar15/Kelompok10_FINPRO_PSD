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
    
    -- Clock period constant
    constant CLK_PERIOD : time := 10 ns;
    
    -- Testbench signals
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal start       : std_logic := '0';
    signal raw_data    : t_data_array := (others => (others => '0'));
    signal sorted_data : t_data_array;
    signal done        : std_logic;
    
    -- Control signal for stopping clock
    signal sim_done    : boolean := false;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: top_sorter
        port map (
            i_clk         => clk,
            i_rst         => rst,
            i_start       => start,
            i_raw_data    => raw_data,
            o_sorted_data => sorted_data,
            o_done        => done
        );
    
    -- Clock Process
    clk_process: process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process clk_process;

    -- Main stimulus and verification process
    stimulus_process: process
    begin
        wait; 
    end process;

end Behavioral;