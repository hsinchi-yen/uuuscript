<<'COMMENTS'
************************************************************************
 Purpose           : For Quick Generate hands-on uuu flash script
 Script name       : UUU_FlashFileGen.sh
 Author            : lancey
 Date created      : 20210514
-----------------------------------------------------------------------
 Revision History  : 1.0
 Date        Author      Ref    Revision (Date in YYYYMMDD format)
-----------------------------------------------------------------------
 20210514   lancey      0      initial draft for PD test purpose for all imx6,imx7,imx8 series
************************************************************************
COMMENTS
SOCNameFinder()
{
  #$1 is the filename
  Img=$1
  SOC_ARR=(imx8 imx7 imx6)

  for SOC in "${SOC_ARR[@]}"; do
    echo "$Img" | grep "$SOC" > /dev/null 2>&1
    Result=$?
    if [[ "$Result" -eq 0 ]]; then
        echo $SOC
        break
    else
        continue
    fi
  done

}

SOMNameFinder()
{
  #$1 is the filename
  Img=$1
  SOM_ARR=(\
   "axon-imx8mm" "edm-g-imx8mm" "flex-imx8mm" "pico-imx8mm" "xore-imx8mm" \
   "axon-imx8mp" "edm-g-imx8mp" \
   "edm-imx8mq" "pico-imx8mq" \
   "edm-g-imx8mn" \
   "edm-imx7" "tep1-imx7" "pico-imx7" \
   "axon-imx6" "edm-imx6" "pico-imx6" "tek-imx6" \
   )

  #imx8mm: axon-imx8mm, edm-g-imx8mm, flex-imx8mm, pico-imx8mm, xore-imx8mm
  #imx8mp: axon-imx8mp, edm-g-imx8mp
  #imx8mq: edm-imx8mq, pico-imx8mq
  #imx8mn: edm-g-imx8mn
  #edm-imx7, tep1-imx7, pico-imx7
  #axon-imx6, edm-imx6, pico-imx6, tek-imx6

  for SOM in "${SOM_ARR[@]}"; do
    echo "$Img" | grep "$SOM" > /dev/null 2>&1
    Result=$?
    if [[ "$Result" -eq 0 ]]; then
        echo $SOM
        break
    else
        continue
    fi
  done

}


EMMCIMAGE="pico-imx6mm_pico-nymph_rescue#134_hdmi_20210312.img"

SOCID=$(SOCNameFinder $EMMCIMAGE)
echo $SOCID

SOMID=$(SOMNameFinder $EMMCIMAGE)
echo $SOM