----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:21 12/01/2017 
-- Design Name: 
-- Module Name:    Vga640480 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library	ieee;
use		ieee.STD_LOGIC_1164.all;
use		ieee.STD_LOGIC_unsigned.all;
use		ieee.STD_LOGIC_arith.all;

entity Vga640480 is
	 port(
			Address		:		  out	STD_LOGIC_VECTOR(13 DOWNTO 0);
			Image			:			in STD_LOGIC_VECTOR(3 downto 0);
			Answer		:			in STD_LOGIC_VECTOR(3 downto 0);
			Reset       :         in  STD_LOGIC;
			Clk25       :		  out STD_LOGIC; 
			Q		    :		  in STD_LOGIC;
			Clk_0       :         in  STD_LOGIC; --50M时钟输入
			Hs,Vs       :         out STD_LOGIC; --行同步、场同步信号
			R,G,B       :         out STD_LOGIC_VECTOR(2 downto 0)
	  );
end Vga640480;

architecture Behavioral of Vga640480 is
	
	signal r1,g1,b1   : STD_LOGIC_VECTOR(2 downto 0);					
	signal hs1,vs1    : STD_LOGIC;				
	signal vector_x : STD_LOGIC_VECTOR(9 downto 0);		--X坐标
	signal vector_y : STD_LOGIC_VECTOR(8 downto 0);		--Y坐标
	signal clk	:	 STD_LOGIC;
begin

Clk25 <= clk;
 -----------------------------------------------------------------------
  process(Clk_0)	--对50M输入信号二分频
    begin
        if(Clk_0'event and Clk_0='1') then 
             clk <= not clk;
        end if;
 	end process;

 -----------------------------------------------------------------------
	 process(clk,Reset)	--行区间像素数（含消隐区）
	 begin
	  	if Reset='0' then
	   		vector_x <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		vector_x <= (others=>'0');
	   		else
	    		vector_x <= vector_x + 1;
	   		end if;
	  	end if;
	 end process;

  -----------------------------------------------------------------------
	 process(clk,Reset)	--场区间行数（含消隐区）
	 begin
	  	if Reset='0' then
	   		vector_y <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others=>'0');
	    		else
	     			vector_y <= vector_y + 1;
	    		end if;
	   		end if;
	  	end if;
	 end process;
 
  -----------------------------------------------------------------------
	 process(clk,Reset) --行同步信号产生（同步宽度96，前沿16）
	 begin
		  if Reset='0' then
		   hs1 <= '1';
		  elsif clk'event and clk='1' then
		   	if vector_x>=656 and vector_x<752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
		  end if;
	 end process;
 
 -----------------------------------------------------------------------
	 process(clk,Reset) --场同步信号产生（同步宽度2，前沿10）
	 begin
	  	if Reset='0' then
	   		vs1 <= '1';
	  	elsif clk'event and clk='1' then
	   		if vector_y>=490 and vector_y<492 then
	    		vs1 <= '0';
	   		else
	    		vs1 <= '1';
	   		end if;
	  	end if;
	 end process;
 -----------------------------------------------------------------------
	 process(clk,Reset) --行同步信号输出
	 begin
	  	if Reset='0' then
	   		Hs <= '0';
	  	elsif clk'event and clk='1' then
	   		Hs <=  hs1;
	  	end if;
	 end process;

 -----------------------------------------------------------------------
	 process(clk,Reset) --场同步信号输出
	 begin
	  	if Reset='0' then
	   		Vs <= '0';
	  	elsif clk'event and clk='1' then
	   		Vs <=  vs1;
	  	end if;
	 end process;
	
 -----------------------------------------------------------------------	
	process(Reset,clk,vector_x,vector_y) -- XY坐标定位控制
	begin  
		if Reset='0' then
			        r1  <= "000";
					g1	<= "000";
					b1	<= "000";	
		elsif(clk'event and clk='1')then
		 			
			if vector_x(9 downto 7) = "001" and vector_y(8 downto 7) = "01" and (Image <= "0101") then
				Address <= Image & vector_y(6 downto 2) & vector_x(6 downto 2);
				if Q = '0' then
					r1 <="111";				  	
					b1 <="111";
					g1 <="111";
				else
					r1  <= "000";
					g1	<= "000";
					b1	<= "000"; 
				end if;
			elsif vector_x(9 downto 5) = "01100" and vector_y(8 downto 5) >= "0011" and (vector_y(8 downto 5)-"0011" <= "1001") then
				Address <= (vector_y(8 downto 5)-"0011") & vector_y(4 downto 0) & vector_x(4 downto 0);
				if Q = '0' then
					r1 <="111";				  	
					b1 <="111";
					g1 <="111";
				else
					r1  <= "000";
					g1	<= "000";
					b1	<= "000"; 
				end if;
			elsif vector_x(9 downto 5) = "01101" and vector_y(8 downto 5) >= "0011" and vector_y(8 downto 5)-"0011" <= "1001" and (vector_y(8 downto 5)-"0011" = Answer) then
				Address <= "1010" & vector_y(4 downto 0) & vector_x(4 downto 0);
				if Q = '0' then
					r1 <="111";				  	
					b1 <="111";
					g1 <="111";
				else
					r1  <= "000";
					g1	<= "000";
					b1	<= "000"; 
				end if;
			else 
					r1  <= "111";
					g1	<= "111";
					b1	<= "111";
			end if;
		end if;		 
	    end process;	

	-----------------------------------------------------------------------
	process (hs1, vs1, r1, g1, b1)	--色彩输出
	begin
		if vector_x < 640 and vector_y < 480 then
			R	<= r1;
			G	<= g1;
			B	<= b1;
		else
			R	<= (others => '0');
			G	<= (others => '0');
			B	<= (others => '0');
		end if;
	end process;

end Behavioral;

