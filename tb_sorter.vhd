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
        variable seed1, seed2 : positive := 1;
        variable rand_val     : real;
        variable int_val      : integer;
        variable test_passed  : boolean;
        variable log_status   : integer;  -- MODUL 7: untuk impure function
        variable min_val : SIGNED(DATA_WIDTH-1 downto 0);
    begin
        -- Test 1: Reset test
        report "========================================" severity note;
        report "Starting Testbench for Bitonic Sorter" severity note;
        report "========================================" severity note;
        
        rst <= '1';
        wait for CLK_PERIOD * 2;
        rst <= '0';
        wait for CLK_PERIOD;
        
        -- MODUL 4: Test 1 - Random data test
        report "Test 1: Generating random test data..." severity note;
        
        -- MODUL 6: FOR LOOP untuk generate random data
        for i in 0 to ARRAY_SIZE-1 loop
            uniform(seed1, seed2, rand_val);
            int_val := integer(rand_val * 1000.0 - 500.0);
            raw_data(i) <= to_signed(int_val, DATA_WIDTH);
        end loop;
        
        -- MODUL 7: Use impure function & pure function
        log_status := log_array(raw_data, "Test1-Input");
        min_val := find_min(raw_data);
        report "Min: " & integer'image(to_integer(min_val)) severity note;
        
        -- Start sorting
        wait for CLK_PERIOD;
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        -- Wait for done signal
        wait until done = '1';
        wait for CLK_PERIOD;
        
        -- Verify sorted output
        report "Checking sorted output..." severity note;
        test_passed := true;
        
        for i in 0 to ARRAY_SIZE-1 loop
            report "Output[" & integer'image(i) & "] = " & 
                   integer'image(to_integer(sorted_data(i))) severity note;
        end loop;
        
        -- Check if array is sorted in ascending order
        for i in 0 to ARRAY_SIZE-2 loop
            assert (sorted_data(i) <= sorted_data(i+1))
                report "SORTING FAILED at index " & integer'image(i) & 
                       ": " & integer'image(to_integer(sorted_data(i))) & 
                       " > " & integer'image(to_integer(sorted_data(i+1)))
                severity error;
            
            if sorted_data(i) > sorted_data(i+1) then
                test_passed := false;
            end if;
        end loop;
        
        if test_passed then
            report "*** TEST 1 PASSED ***" severity note;
        else
            report "*** TEST 1 FAILED ***" severity error;
        end if;
        
        wait for CLK_PERIOD * 5;
        
        wait; -- Temporary wait to prevent infinite loop before next commits
    end process stimulus_process;

end Behavioral;