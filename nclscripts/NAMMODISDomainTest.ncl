
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin
;---------------------------------------------------------------------
fils2 = systemfunc("ls /mnt/datadrive/xsun/work/run_NAMMODIS/wrfout_d04*")
f1 = addfile("/mnt/datadrive/xsun/work/run_NARR/wrfout_d04_2014-09-21_00:00:00.nc","r")
;f12 = addfile("/mnt/datadrive/xsun/work/run_NARR/wrfout_d03_2014-09-21_00:00:00.nc","r")
;f13 = addfile("/mnt/datadrive/xsun/work/run_NARR/d0102Rerun/wrfout_d02_2014-09-21_00:00:00.nc","r")
;f14 = addfile("/mnt/datadrive/xsun/work/run_NARR/d0102Rerun/wrfout_d01_2014-09-21_00:00:00.nc","r")
fils22 = systemfunc("ls /mnt/datadrive/xsun/work/run_NAMMODIS/wrfout_d03*")
fils23 = systemfunc("ls /mnt/datadrive/xsun/work/run_NAMMODIS/wrfout_d02*")
fils24 = systemfunc("ls /mnt/datadrive/xsun/work/run_NAMMODIS/wrfout_d01*")
f2 = addfiles(fils2,"r")
f22 = addfiles(fils22,"r")
f23 = addfiles(fils23,"r")
f24 = addfiles(fils24,"r")


ListSetType(f2,"cat")
ListSetType(f22,"cat")
ListSetType(f23,"cat")
ListSetType(f24,"cat")
;f3 = addfile("/mnt/datadrive/xsun/work/run_NARR/wrfout_d04_2014-09-21_00:00:00.nc","r")
;----------------------------------------------------------------------------
  lat = 45.713560
  lon = -119.406023
  llres = True
  llres@ReturnInt = True ; Return integer values
  locij = wrf_user_ll_to_ij(f1, lon, lat, llres)
  locij = locij -1
  locX = locij(0)
  locY = locij(1)

;------------------------------------------------------------------------------
 ; type = "HFX" 
 ; type = "UST"
 ; type1 = "U10"
  ;type2 ="V10"
 ; type = "T2"
  type = "LH"
  ustar1 = wrf_user_getvar(f2, type, -1)
  ustar1_point =ustar1(:, locY, locX)

  ustar2 = wrf_user_getvar(f22, type, -1)
  ustar2_point =ustar2(:, locY, locX)

 ustar3 = wrf_user_getvar(f23, type, -1)
  ustar3_point =ustar3(:, locY, locX)

 ustar4 = wrf_user_getvar(f24, type, -1)
  ustar4_point =ustar4(:, locY, locX)




  ;ustar2 = f2[:]->HFX
  ;ustar2_point = ustar2(:, locY, locX)
  ;ustar3 = wrf_user_getvar(f3,"HFX", -1)
  ;ustar3_point = ustar3(:, locY, locX);
;------------------------------------------------------------------------------
  timess = wrf_times_c(f1->Times,0)

  ntimes = dimsizes(timess)-5
  times = timess -8 ; LST time

  print(times)
  copy_VarAtts(timess, times)



;----creat array to save paramers----------------------------------------------
  ustar = new ((/4,193/),float)
  ustar(0, 0:192) = ustar1_point
  ustar(1, 0:192) = ustar2_point
  ustar(2, 0:192) = ustar3_point
 ustar(3, 0:192) = ustar4_point

;-----------------------------------------------------------------
  ; wks = gsn_open_wks("ps", "NAMMODISSHF")
 ;  wks = gsn_open_wks("ps", "NAMMODISSTAR")
 ;  wks = gsn_open_wks("ps", "NAMMODIST2")
   wks = gsn_open_wks("ps", "NAMMODISLHF")
;  wks = gsn_open_wks("x11", "Modles Performance")
;--------set resources
  res = True
  res@xyExplicitLegendLabels = (/"NAM-ACM2(MODIS) d04","NAM-ACM2(MODIS) d03","NAM-ACM2(MODIS) d02", "NAM-ACM2(MODIS) d01"/)
  res@xyLineColors = (/"blue","red","green", "Grey"/)
  res@xyLineThicknessF = 3
 ; res@tiYAxisString = "SHF (W.m~S~-2~N~)"
 ; res@tiYAxisString = "u*(m.s~S~-1)"
;res@tiYAxisString = "Temp at 2m (K)"
 res@tiYAxisString = "LHF (W.m~S~-2~N~)"
  res@tiYAxisFont = 21
  res@tiYAxisFontHeightF = 0.012
 ; res@trYMinF = 0.0
 ; res@trYMaxF = 150
  res@trXMinF = times(44) ;43
  res@trXMaxF = times(188) ;187
  res@gsnMaximize = True
  res@gsnDraw = False
  res@gsnFrame = False
  res@vpWidthF = 0.8
  res@vpHeightF = 0.3
  res@pmLegendDisplayMode = "Always"
  res@lgLabelFontHeightF = 0.01
  res@pmLegendWidthF = 0.04
  res@lgPerimOn = False  ;turn off box around
  res@pmLegendHeightF = 0.09
  res@pmLegendOrthogonalPosF = -1.25 ;move units down
  res@pmLegendParallelPosF = 0.12 ;move unit right
  res@tmXBLabelFontHeightF = 0.0075 ;x axis label size
 ;-----------set axis
 restick = True
   restick@ttmFormat = "%D-%c %H:%M"
; restick@ttmMajorStride=12 ;change the lable numbers
  restick@ttmMinorStride=4
 restick@ttmValues=(/(/2014,9,22,12,0,0/),\
                     (/2014,9,23,0,0,0/),\
                     (/2014,9,23,12,0,0/),\
                     (/2014,9,24,0,0,0/),\
                     (/2014,9,24,12,0,0/),\
                     (/2014,9,25,0,0,0/),\
                     (/2014,9,25,12,0,0/),\
                     (/2014,9,26,0,0,0/),\
                     (/2014,9,26,12,0,0/),\
                     (/2014,9,27,0,0,0/),\
                     (/2014,9,27,12,0,0/),\
                     (/2014,9,28,0,0,0/),\
                     (/2014,9,28,12,0,0/)/)

  time_axis_labels(times,res,restick)
;---------------------------
plot = gsn_csm_xy(wks,times,ustar,res)


;-----------
draw(plot)
frame(wks)

end















