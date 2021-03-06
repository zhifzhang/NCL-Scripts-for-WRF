
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
begin
;---------------------------------------------------------------------

;f1 = addfile("/home/xsun/model/xsun/soft/WRFV3/run_NAMYSUNEW/wrfinput_d04.nc","r")  ;modify the cnmaxlevel too, MODIS is 20 and USGS is 24
f1= addfile("/home/xsun/model/xsun/soft/WRFV3/run/wrfout_d04_2014-09-21_00:00:000","r")
f2= addfile("/home/xsun/model/xsun/work/run_NAMNG/nuisttar/wrfout_d04_2014-09-21_00:00:00","r")
f3= addfile("/home/xsun/model/xsun/work/run_NARR/wrfout_d04_2014-09-27_00:00:00","r")
f4= addfile("/home/xsun/model/xsun/work/run_NAMACMMODIS/wrfout_d04_2014-09-27_00:00:00","r")
f5= addfile("/home/xsun/model/xsun/work/run_NAMYSUMODIS/wrfout_d04_2014-09-27_00:00:00","r")
f6= addfile("/home/xsun/model/xsun/work/run_NAMMYJMODIS/wrfout_d04_2014-09-27_00:00:00","r")
;------overlay to countours on map ----------------------------------------------------------------------
  

;------------------------------------------------------------------------------
;landuse = f1->LU_INDEX(0,:,:)
LHF = f1->LH(21,:,:)
SHF=f1->HFX(21,:,:)
 wks = gsn_open_wks("pdf", "Bowen_USGS_ACM")
  gsn_define_colormap(wks, "rainbow")
  Bowen = SHF/LHF
   copy_VarAtts(SHF, Bowen)
;  wks = gsn_open_wks("x11", "Modles Performance")

;--------set resources
  res = True
  ;res@Footer=False
 ; res@tiMainString = "NAM-ACM2(MODIS)"
  ; res@tiMainString = "NAM-ACM2"
  ;  res@tiMainString = "NARR-ACM2"
  ;res@tiMainString = "NAM-ACM2(Non-nudge)"
  res@gsnDraw              = False
  res@gsnFrame             = False
  res@Footer = False
  res@InitTime = False
  res@gsnMaximize = True
    res@cnFillOn    = True
  res@tfDoNDCOverlay = True
 res@gsnSpreadColors = True

  res@cnFillOn = True
  res@cnLineLabelsOn = False 
 res@cnLinesOn = False
  res@cnInfoLabelOn = False
res@gsnLeftString = " "
res@gsnRightString = " "
 res@pmLabelBarHeightF = 0.3
  res@pmLabelBarWidthF = 0.8
 res@lbLabelFontHeightF = 0.0155
 res@pmLabelBarOrthogonalPosF = -0.15 ;label bar vertical position
 res@pmLabelBarParallelPosF = 0.5  ;label bar horizontal position
  ;res = wrf_map_resources(f1, res)
  ;res@mpMinLonF = -119.5
  ;res@mpMaxLonF = -119.3
  ;res@mpMinLatF = 45.0
  ;res@mpMaxLatF = 45.4
  ;res@mpGeophysicalLineColor = "Black"
  ;res@mpNationalLineColor    = "Black"
  ;res@mpUSStateLineColor     = "Black"
  ;res@mpGridLineColor        = "Black"
  ;res@mpLimbLineColor        = "Black"
  ;res@mpPerimLineColor       = "Black"
;res@mpUSStateLineThicknessF = 2.0
 ; res@mpMinLatF = 45.0 
 ;res@cnFillDrawOrder = "PreDraw"
  opts=res

 ; opts@lbOrientation = "Vertical"
  opts@cnFillOn = True
  ;opts@cnFillMode = "RasterFill"   ;for 2D information,pixles
  opts@cnLevelSelectionMode = "ManualLevels"
 opts@cnMinLevelValF = 0
; cnLevelSpacingF
opts@cnLevelSpacingF = 1
opts@cnMaxLevelValF = 10   
opts@lbLabelStride =1 
 opts@tmXBLabelFontHeightF = 0.055
  opts@tmYLLabelFontHeightF=0.055
;opts@lbLabelConstantSpacingF =1
;opts@cnLineDashPattern = 1
 ; opts@ContourParameters = (/1,20,1/)
;contour=wrf_contour(f1, wks, landuse,opts)
 plota=wrf_contour(f1, wks, Bowen, opts)



;overlay(plot,plotb)
; plota=gsn_csm_contour_map_overlay(wks, landuse(0,:,:), hgt(0,:,:), opts, res2)
  pltres= True

  ; pltres@gsnDraw              = False
   pltres@gsnFrame             = False   ; save for dispal  wks
  pltres@tmXBLabelFontHeightF = 0.55
  pltres@tmYLLabelFontHeightF=0.55
  ;pltres@NoTitles = True  ;move any titles in the map
  mpres = True
  ;mpres@mpMinLonF = -119.5
  ;mpres@mpMaxLonF = -119.3
  ;mpres@mpMinLatF = 45.0
 ; mpres@mpMaxLatF = 45.4
  mpres@mpGeophysicalLineColor = "Black"
  mpres@mpNationalLineColor    = "Black"
  mpres@mpUSStateLineColor     = "Black"
  mpres@mpGridLineColor        = "Black"
  mpres@mpLimbLineColor        = "Black"
  mpres@mpPerimLineColor       = "Black"
  mpres@tmXBLabelFontHeightF = 0.0155
  mpres@tmYLLabelFontHeightF=0.0155
  mpres@mpUSStateLineThicknessF = 2.0
  ;res@mpMinLatF = 45.0 
 plot = wrf_map_overlays(f1,wks,(/plota/), pltres,mpres)
 pmres = True
  pmres@gsMarkerColor = "Black"
  pmres@gsMarkerIndex = 4
  pmres@gsMarkerSizeF = 0.015
  pmres@gsMarkerThicknessF = 3.0
 ;plot = wrf_map_overlays(f1, wks, (/contour/),pltres,mpres) 
 marker=gsn_add_polymarker(wks,plot,-119.406023,45.713560,pmres)

draw(plot)
; draw(marker)
 frame(wks)           ; lets frame the plot - do not delete

end















