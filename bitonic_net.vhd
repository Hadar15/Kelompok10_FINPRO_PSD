library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.sorter_pkg.all;

entity bitonic_net is
    Port (
        i_data : in  t_data_array;  
        o_data : out t_data_array   
    );
end bitonic_net;

architecture Structural of bitonic_net is

    component cas_unit is
        Port (
            i_val_a : in  SIGNED(DATA_WIDTH-1 downto 0);
            i_val_b : in  SIGNED(DATA_WIDTH-1 downto 0);
            o_min   : out SIGNED(DATA_WIDTH-1 downto 0);
            o_max   : out SIGNED(DATA_WIDTH-1 downto 0)
        );
    end component;
    
    constant NUM_STAGES : integer := 10;  
    
    type t_stage_array is array (0 to NUM_STAGES) of t_data_array;
    signal stage : t_stage_array;
    
begin

    stage(0) <= i_data;
    
    gen_stage1: for i in 0 to 7 generate
        cas1: cas_unit port map(
            i_val_a => stage(0)(2*i),
            i_val_b => stage(0)(2*i+1),
            o_min   => stage(1)(2*i),
            o_max   => stage(1)(2*i+1)
        );
    end generate;
    
    gen_stage2: for i in 0 to 3 generate
        cas2a: cas_unit port map(
            i_val_a => stage(1)(4*i),
            i_val_b => stage(1)(4*i+3),
            o_min   => stage(2)(4*i),
            o_max   => stage(2)(4*i+3)
        );
        cas2b: cas_unit port map(
            i_val_a => stage(1)(4*i+1),
            i_val_b => stage(1)(4*i+2),
            o_min   => stage(2)(4*i+1),
            o_max   => stage(2)(4*i+2)
        );
    end generate;
    
    gen_stage3: for i in 0 to 3 generate
        cas3: cas_unit port map(
            i_val_a => stage(2)(4*i),
            i_val_b => stage(2)(4*i+1),
            o_min   => stage(3)(4*i),
            o_max   => stage(3)(4*i+1)
        );
        cas3b: cas_unit port map(
            i_val_a => stage(2)(4*i+2),
            i_val_b => stage(2)(4*i+3),
            o_min   => stage(3)(4*i+2),
            o_max   => stage(3)(4*i+3)
        );
    end generate;
    
    gen_stage4: for i in 0 to 1 generate
        cas4a: cas_unit port map(
            i_val_a => stage(3)(8*i),
            i_val_b => stage(3)(8*i+7),
            o_min   => stage(4)(8*i),
            o_max   => stage(4)(8*i+7)
        );
        cas4b: cas_unit port map(
            i_val_a => stage(3)(8*i+1),
            i_val_b => stage(3)(8*i+6),
            o_min   => stage(4)(8*i+1),
            o_max   => stage(4)(8*i+6)
        );
        cas4c: cas_unit port map(
            i_val_a => stage(3)(8*i+2),
            i_val_b => stage(3)(8*i+5),
            o_min   => stage(4)(8*i+2),
            o_max   => stage(4)(8*i+5)
        );
        cas4d: cas_unit port map(
            i_val_a => stage(3)(8*i+3),
            i_val_b => stage(3)(8*i+4),
            o_min   => stage(4)(8*i+3),
            o_max   => stage(4)(8*i+4)
        );
    end generate;
    
    gen_stage5: for i in 0 to 1 generate
        gen_stage5_inner: for j in 0 to 1 generate
            cas5a: cas_unit port map(
                i_val_a => stage(4)(8*i+4*j),
                i_val_b => stage(4)(8*i+4*j+3),
                o_min   => stage(5)(8*i+4*j),
                o_max   => stage(5)(8*i+4*j+3)
            );
            cas5b: cas_unit port map(
                i_val_a => stage(4)(8*i+4*j+1),
                i_val_b => stage(4)(8*i+4*j+2),
                o_min   => stage(5)(8*i+4*j+1),
                o_max   => stage(5)(8*i+4*j+2)
            );
        end generate;
    end generate;
    
    gen_stage6: for i in 0 to 1 generate
        gen_stage6_inner: for j in 0 to 3 generate
            cas6: cas_unit port map(
                i_val_a => stage(5)(8*i+2*j),
                i_val_b => stage(5)(8*i+2*j+1),
                o_min   => stage(6)(8*i+2*j),
                o_max   => stage(6)(8*i+2*j+1)
            );
        end generate;
    end generate;
    
    cas7_0: cas_unit port map(stage(6)(0), stage(6)(15), stage(7)(0), stage(7)(15));
    cas7_1: cas_unit port map(stage(6)(1), stage(6)(14), stage(7)(1), stage(7)(14));
    cas7_2: cas_unit port map(stage(6)(2), stage(6)(13), stage(7)(2), stage(7)(13));
    cas7_3: cas_unit port map(stage(6)(3), stage(6)(12), stage(7)(3), stage(7)(12));
    cas7_4: cas_unit port map(stage(6)(4), stage(6)(11), stage(7)(4), stage(7)(11));
    cas7_5: cas_unit port map(stage(6)(5), stage(6)(10), stage(7)(5), stage(7)(10));
    cas7_6: cas_unit port map(stage(6)(6), stage(6)(9), stage(7)(6), stage(7)(9));
    cas7_7: cas_unit port map(stage(6)(7), stage(6)(8), stage(7)(7), stage(7)(8));
    
    gen_stage8: for i in 0 to 1 generate
        cas8a: cas_unit port map(stage(7)(8*i), stage(7)(8*i+7), stage(8)(8*i), stage(8)(8*i+7));
        cas8b: cas_unit port map(stage(7)(8*i+1), stage(7)(8*i+6), stage(8)(8*i+1), stage(8)(8*i+6));
        cas8c: cas_unit port map(stage(7)(8*i+2), stage(7)(8*i+5), stage(8)(8*i+2), stage(8)(8*i+5));
        cas8d: cas_unit port map(stage(7)(8*i+3), stage(7)(8*i+4), stage(8)(8*i+3), stage(8)(8*i+4));
    end generate;
    
    gen_stage9: for i in 0 to 3 generate
        cas9a: cas_unit port map(stage(8)(4*i), stage(8)(4*i+3), stage(9)(4*i), stage(9)(4*i+3));
        cas9b: cas_unit port map(stage(8)(4*i+1), stage(8)(4*i+2), stage(9)(4*i+1), stage(9)(4*i+2));
    end generate;
    
    gen_stage10: for i in 0 to 7 generate
        cas10: cas_unit port map(
            i_val_a => stage(9)(2*i),
            i_val_b => stage(9)(2*i+1),
            o_min   => stage(10)(2*i),
            o_max   => stage(10)(2*i+1)
        );
    end generate;
    
    o_data <= stage(10);

end Structural;
