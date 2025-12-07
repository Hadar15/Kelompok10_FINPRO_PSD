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

    -- MODUL 8: FSM State Type
    type t_state is (IDLE, LOAD, SORTING, DONE);
    signal current_state, next_state : t_state;
    
    signal process_counter : integer range 0 to 5;
    signal done_reg : std_logic;

    -- MODUL 9: Microprogramming - Control signals ROM
    type t_control_word is record
        load_en   : std_logic;
        sort_en   : std_logic;
        latch_en  : std_logic;
        done_flag : std_logic;
    end record;
    
    type t_microcode is array (0 to 3) of t_control_word;
    constant MICROCODE : t_microcode := (
        0 => ('0', '0', '0', '0'),  -- IDLE
        1 => ('1', '0', '0', '0'),  -- LOAD
        2 => ('0', '1', '0', '0'),  -- SORTING
        3 => ('0', '0', '1', '1')   -- DONE
    );
    
    signal control_signals : t_control_word;

begin

    -- MODUL 5: Structural MOdel
    bitonic_inst: bitonic_net
        port map (
            i_data => reg_input_data,
            o_data => net_output
        );

    -- MODUL 9: Microcode decoder - fetch control signals from ROM
    control_signals <= MICROCODE(t_state'pos(current_state));
    
    -- MODUL 8: FSM State Register
    state_register: process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            current_state <= IDLE;
        elsif rising_edge(i_clk) then
            current_state <= next_state;
        end if;
    end process state_register;
    
    -- FSM: Next State Logic (Combinational)
    next_state_logic: process(current_state, i_start, process_counter)
    begin
        -- Default: stay in current state
        next_state <= current_state;
        
        case current_state is
            when IDLE =>
                if i_start = '1' then
                    next_state <= LOAD;
                end if;
            
            when LOAD =>
                next_state <= SORTING;
            
            when SORTING =>
                -- PERBAIKAN: Tingkatkan delay counter untuk stabilitas
                if process_counter >= 3 then
                    next_state <= DONE;
                end if;
            
            when DONE =>
                if i_start = '0' then
                    next_state <= IDLE;
                end if;
            
            when others =>
                next_state <= IDLE;
        end case;
    end process next_state_logic;
    
    -- FSM: Output Logic (Combinational)
    output_logic: process(current_state, reg_output_data)
    begin
        -- Default values
        done_reg <= '0';
        
        case current_state is
            when DONE =>
                done_reg <= '1';
            when others =>
                done_reg <= '0';
        end case;
    end process output_logic;
    
    -- Assign output
    o_done <= done_reg;
    
    -- MODUL 9 & 8: Datapath controlled by microcode signals
    datapath_proc: process(i_clk, i_rst)
        variable temp_idx : integer := 0;
    begin
        if i_rst = '1' then
            reg_input_data  <= (others => (others => '0'));
            reg_output_data <= (others => (others => '0'));
            o_sorted_data   <= (others => (others => '0'));
            process_counter <= 0;
        elsif rising_edge(i_clk) then
            
            -- MODUL 9: Use microcode control signals
            if control_signals.load_en = '1' then
                reg_input_data  <= i_raw_data;
                process_counter <= 0;
            end if;
            
            if control_signals.sort_en = '1' then
                -- MODUL 6: LOOP construct untuk counter
                if process_counter < 5 then
                    process_counter <= process_counter + 1;
                end if;
                
                if process_counter = 3 then
                    reg_output_data <= net_output;
                end if;
            end if;
            
            if control_signals.latch_en = '1' then
                o_sorted_data <= reg_output_data;
            end if;
            
            -- MODUL 6: Simple FOR loop example in datapath
            if current_state = IDLE then
                process_counter <= 0;
                temp_idx := 0;
                -- Reset logic with loop
                for i in 0 to 3 loop
                    temp_idx := temp_idx + 1;
                end loop;
            end if;
            
        end if;
    end process datapath_proc;        

end Behavioral;