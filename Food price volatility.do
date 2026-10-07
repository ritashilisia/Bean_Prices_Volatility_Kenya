FOOD PRICE PORTFOLIO PROJECT
**Research question: which region has the highest bean price volatility in Kenya?
Step 1: Data and Panel Setup
**import data, rename, check variable type
rename adm1_name region
rename adm2_name subregion
rename mkt_name market
rename price_date date

**we assign numeric values to region, subregion and market so we work with them
encode region, generate (regionid)
encode subregion, generate (subregionid)
encode market, generate (marketid)

**turns date into a format Stata understands
gen date_d = date(date, "MDY")
format date_d %td 

**creates my own monthly panel to use for time-series plotting
gen time_m = ym(year, month)


**checks if the two variables align
format time_m %tm 
list date date_d in 1/12 


***this tells stata that this is panel data and(marketid) and (time_m) are the identifying variables
***this is a declaration step, it tells stata how to see your data. Helpful when you want to run other panel commands e.g xtreg, xtsum
***catches errors fast, flags if there's imbalance in the market, month data and also shows the range of time variable
xtset marketid time_m

**summarizing the variable c_beans to see if there are any zero values in the minimum values within various percentiles
**count to show the number of zero variables in the data
sum c_beans, detail 
count if c_beans == 0
count if h_beans == 0
count if l_beans == 0  

***checks if there's one observation per market per month
duplicates report marketid time_m

***this is a sanity check, to see if months follow the expected order and if the time starts where it's expected
list marketid time_m if marketid == 1, sepby(marketid)

***volatility was calculated using the parkinson's method-captures more information than a simple standard deviation of prices and statistically more efficient
***this is per month, per market, there are 234 markets
gen vol_parkinson = sqrt((1/(4*ln(2))) * (ln(h_beans/l_beans))^2)
sum vol_parkinson, detail

***plotting it on a histogram to see the overall trend of bean volatility
histogram vol_parkinson, bin(50)

***we want to preserve the vol_parkinson data because we want to consolidate the markets per region. Preserve helps us restore it
preserve

***this gives us data on volatility per region, markets in one region are consolidated
collapse (mean) vol_parkinson, by(regionid time_m)

***confirms data is now per region per month panel, you see how many regions you have
xtset regionid time_m
describe
restore

**this gives linear visualization of volatility per region over the time period
xtline vol_parkinson, overlay

preserve

**decoding helps us select our 4 chosen regions by name
decode regionid, gen(region_str)
keep if inlist(region_str, "Meru", "Embu", "Nairobi", "Coast")

**twoway in STATA needs the data in wide format, which means that volatility for each region will appear as its own column variables
**twoway then plots volatility for all regions as separate lines against time
reshape wide vol_parkinson regionid, i(time_m) j(region_str) string
twoway ///
    (line vol_parkinsonMeru time_m, lcolor(red)) ///
    (line vol_parkinsonEmbu time_m, lcolor(navy)) ///
    (line vol_parkinsonNairobi time_m, lcolor(orange)) ///
    (line vol_parkinsonCoast time_m, lcolor(green)), ///
    legend(label(1 "Meru") label(2 "Embu") label(3 "Nairobi") label(4 "Coast")) ///
    ytitle("Parkinson Volatility") xtitle("Time") ///
    title("Food Price Volatility: High vs. Low Volatility Regions")
	
	
twoway ///
    (line vol_parkinsonMeru time_m if time_m>=tm(2015m1), lcolor(red)) ///
    (line vol_parkinsonEmbu time_m if time_m>=tm(2015m1), lcolor(navy)) ///
    (line vol_parkinsonNairobi time_m if time_m>=tm(2015m1), lcolor(orange)) ///
    (line vol_parkinsonCoast time_m if time_m>=tm(2015m1), lcolor(green)), ///
    legend(label(1 "Meru") label(2 "Embu") label(3 "Nairobi") label(4 "Coast")) ///
    ytitle("Parkinson Volatility") xtitle("Time") ///
    title("Food Price Volatility: High vs. Low Volatility Regions") ///
    subtitle("January 2015 - Present")
	
	








