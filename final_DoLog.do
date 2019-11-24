import delimited "/Users/volneyrichardson/Advanced_econ/final_project/national_savings.csv"

tsset year

# test for unit root
dfulller savingsusa
dfulller deficitusa

#generate differenced savings
gen dsavingsAUS = d.savingsaus
gen dsavingsAUT = d.savingsaut
gen dsavingsBEL = d.savingsbel
gen dsavingsCAN = d.savingscan
gen dsavingsCHE = d.savingsche
gen dsavingsDEU = d.savingsdeu
gen dsavingsDNK = d.savingsdnk
gen dsavingsESP = d.savingsesp
gen dsavingsFIN = d.savingsfin
gen dsavingsFRA = d.savingsfra
gen dsavingsGBR = d.savingsgbr
gen dsavingsGRC = d.savingsgrc
gen dsavingsIRL = d.savingsirl
gen dsavingsITA = d.savingsita
gen dsavingsJPN = d.savingsjpn
gen dsavingsNLD = d.savingsnld
gen dsavingsNOR = d.savingsnor
gen dsavingsUSA = d.savingsusa

#generate differenced deficit
gen ddeficitAUS = d.deficitaus
gen ddeficitAUT = d.deficitaut
gen ddeficitBEL = d.deficitbel
gen ddeficitCAN = d.deficitcan
gen ddeficitCHE = d.deficitche
gen ddeficitDEU = d.deficitdeu
gen ddeficitDNK = d.deficitdnk
gen ddeficitESP = d.deficitesp
gen ddeficitFIN = d.deficitfin
gen ddeficitFRA = d.deficitfra
gen ddeficitGBR = d.deficitgbr
gen ddeficitGRC = d.deficitgrc
gen ddeficitIRL = d.deficitirl
gen ddeficitITA = d.deficitita
gen ddeficitJPN = d.deficitjpn
gen ddeficitNLD = d.deficitnld
gen ddeficitNOR = d.deficitnor
gen ddeficitUSA = d.deficitusa

# estimate lag length
varsoc ddeficitUSA dsavingsUSA
# make the long run matrix
matrix C = (.,0\.,.)


# for each country estimate the svar

svar ddeficitAUS dsavingsAUS , lags(1/3) lreq(C)
svar ddeficitAUT dsavingsAUT , lags(1/3) lreq(C)
svar ddeficitBEL dsavingsBEL , lags(1/3) lreq(C)
svar ddeficitCAN dsavingsCAN , lags(1/3) lreq(C)
svar ddeficitDEU dsavingsDEU , lags(1/3) lreq(C)
svar ddeficitDNK dsavingsDNK , lags(1/3) lreq(C)
svar ddeficitESP dsavingsESP , lags(1/3) lreq(C)
svar ddeficitFIN dsavingsFIN , lags(1/3) lreq(C)
svar ddeficitFRA dsavingsFRA , lags(1/3) lreq(C)
svar ddeficitGBR dsavingsGBR , lags(1/3) lreq(C)
svar ddeficitGRC dsavingsGRC , lags(1/3) lreq(C)
svar ddeficitIRL dsavingsIRL , lags(1/3) lreq(C)
svar ddeficitITA dsavingsITA , lags(1/3) lreq(C)
svar ddeficitJPN dsavingsJPN , lags(1/3) lreq(C)
svar ddeficitNLD dsavingsNLD , lags(1/3) lreq(C)
svar ddeficitNOR dsavingsNOR , lags(1/3) lreq(C)
svar ddeficitUSA dsavingsUSA , lags(1/3) lreq(C)

# first run one above svar and then run the next 3 lines for cholesky decomposition
matrix esig = e(Sigma)
matrix cvar = cholesky(esig)
matlist cvar

# create irf file and graph irf credit to: https://blog.stata.com/2016/10/27/long-run-restrictions-in-a-structural-vector-autoregression/
irf create lrvar, set(lrirf) step(40) replace
use lrirf.irf, clear
sort irfname impulse response step
gen csirf = sirf
by irfname impulse: replace csirf = sum(sirf) if response=="dsavingsUSA"
order irfname impulse response step sirf csirf
save lrirf2.irf, replace
irf set lrirf2.irf
irf graph csirf, yline(0,lcolor(black)) noci xlabel(0(4)40) byopts(yrescale)


# my extension
clear
import delimited "/Users/volneyrichardson/Advanced_econ/final_project/deficit and interest.csv"
tsset year
matrix C = (.,0\.,.)
gen dif_interest = d.interestrate
gen dif_deficit = d.deficit
varsoc dif_deficit dif_interest
# 3 lags indentified
svar dif_deficit dif_interest , lags(1/3) lreq(C)
matrix esig = e(Sigma)
matrix cvar = cholesky(esig)
matlist cvar

irf create lrvar, set(lrirf) step(40) replace
use lrirf.irf, clear
sort irfname impulse response step
gen csirf = sirf
by irfname impulse: replace csirf = sum(sirf) if response=="dif_interest"
order irfname impulse response step sirf csirf
save lrirf2.irf, replace
irf set lrirf2.irf
irf graph csirf, yline(0,lcolor(black)) noci xlabel(0(4)40) byopts(yrescale)




