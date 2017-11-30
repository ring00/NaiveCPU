library ieee;
use ieee.std_logic_1164.all;

entity Keyboard is
	port (
		ps2_data, ps2_clk: in std_logic;
		clk, rst: in std_logic;
		ax, ay: out integer
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;

entity KeyboardToWASD is
	port (
		ps2_data, ps2_clk: in std_logic;
		clk, rst: in std_logic;
		w, a, s, d, up, left, down, right: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;

entity WASDToAcc is
	port (
		w, a, s, d: in std_logic;
		ax, ay: out integer
	);
end entity;

entity CPUKeyboard is
	port (
		ps2_data, ps2_clk: in std_logic;
		clk, rst: in std_logic;
		done: in std_logic;
		ok: out std_logic;
		key: out std_logic_vector(7 downto 0)
	);
end entity;

--------------------------------------------------

architecture arch of Keyboard is
	component KeyboardToWASD is
		port (
			ps2_data, ps2_clk: in std_logic;
			clk, rst: in std_logic;
			w, a, s, d: out std_logic
		);
	end component;
	component WASDToAcc is
		port (
			w, a, s, d: in std_logic;
			ax, ay: out integer
		);
	end component;
	signal w, a, s, d: std_logic;
begin
	ktw: KeyboardToWASD port map (ps2_data, ps2_clk, clk, rst, w, a, s, d);
	wta: WASDToAcc port map (w, a, s, d, ax, ay);
end arch ; -- arch


architecture arch of KeyboardToWASD is
	component KeyboardScancode is
	port (
		datain, clkin : in std_logic ; -- PS2 clk and data
		fclk, rst : in std_logic ;  -- filter clock
		ok : out std_logic ;
		scancode : out std_logic_vector(7 downto 0) -- scan code signal output
		);
	end component ;
	signal ok: std_logic;
	signal scancode, last1, last2, lastclk: std_logic_vector(7 downto 0) := x"00";
	signal w1, a1, s1, d1, up1, down1, left1, right1: std_logic := '0';
	signal isBreak, isE0: boolean := false;
	constant c_break: std_logic_vector(7 downto 0) := x"F0";
	constant c_E0: std_logic_vector(7 downto 0) := x"E0";
	constant c_w: std_logic_vector(7 downto 0) := x"1D";
	constant c_a: std_logic_vector(7 downto 0) := x"1C";
	constant c_s: std_logic_vector(7 downto 0) := x"1B";
	constant c_d: std_logic_vector(7 downto 0) := x"23";
	constant c_up: std_logic_vector(7 downto 0) := x"75";
	constant c_left: std_logic_vector(7 downto 0) := x"6B";
	constant c_down: std_logic_vector(7 downto 0) := x"72";
	constant c_right: std_logic_vector(7 downto 0) := x"74";
begin
	ks: KeyboardScancode port map (ps2_data, ps2_clk, clk, rst, ok, scancode);

	isbreak <= last1 = c_break;
	isE0 <= last1 = c_E0 or last2 = c_E0;
	w <= w1; a <= a1; s <= s1; d <= d1;
	up <= up1; down <= down1; left <= left1; right <= right1;
	
	process( clk )
	begin
		if rising_edge(clk) and ok = '1' then
		case( scancode ) is
			when c_w => if isBreak then w1 <= '0'; else w1 <= '1'; end if;
			when c_a => if isBreak then a1 <= '0'; else a1 <= '1'; end if;
			when c_s => if isBreak then s1 <= '0'; else s1 <= '1'; end if;
			when c_d => if isBreak then d1 <= '0'; else d1 <= '1'; end if;
			when c_up => if isE0 then if isBreak then up1 <= '0'; else up1 <= '1'; end if; end if;
			when c_down => if isE0 then if isBreak then down1 <= '0'; else down1 <= '1'; end if; end if;
			when c_left => if isE0 then if isBreak then left1 <= '0'; else left1 <= '1'; end if; end if;
			when c_right => if isE0 then if isBreak then right1 <= '0'; else right1 <= '1'; end if; end if;
			when others => null;
		end case ;
		last2 <= last1;
		last1 <= scancode;
		end if;
	end process ;
end arch ; -- arch


architecture arch of WASDToAcc is
begin
	ay <= 1 when s = '1' else -1 when w = '1' else 0;
	ax <= 1 when d = '1' else -1 when a = '1' else 0;
end arch ; -- arch

architecture arch of CPUKeyboard is 
	component KeyboardToWASD is
		port (
			ps2_data, ps2_clk: in std_logic;
			clk, rst: in std_logic;
			w, a, s, d: out std_logic
		);
	end component;
	signal w, a, s, d: std_logic;
	signal last_key: std_logic_vector(7 downto 0);
begin
	ktw: KeyboardToWASD port map (ps2_data, ps2_clk, clk, rst, w, a, s, d);
	key <= last_key;
	process( clk )
	begin
		if rising_edge(clk) then
			if done = '1' then
				ok <= '0'
			else
				if w = '1' and last_key /= x"77" then
					last_key <= x"77";
					ok <= '1';
				end if;
				if a = '1' and last_key /= x"61" then
					last_key <= x"61";
					ok <= '1';
				end if;
				if s = '1' and last_key /= x"73" then
					last_key <= x"73";
					ok <= '1';
				end if;
				if d = '1' and last_key /= x"64" then
					last_key <= x"64";
					ok <= '1';
				end if;
			end if;
		end if;
	end process;
end arch;