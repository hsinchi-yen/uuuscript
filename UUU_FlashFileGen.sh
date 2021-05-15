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
  SOC_ARR=(imx8mm imx8mn imx8mq imx8mp imx6 imx6ul imx7)

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

EMMCIMAGE="tek-imx6_pico-nymph_rescue#134_hdmi_20210312.img"
FLASHCODE="imx8_flash_code.sh"

#Flash EMMC script post-fixed word.

#common path definition
UUU="uuu_flash"
IMX_UUU_TOOL="/Downloads/imx-mfg-uuu-tool"
UUU_DST="/uuu/linux64/uuu"

#for imx8 series
BOARDTYPE_Tail="-flash.bin"

#for imx6 / imx7 series
SPL="-SPL"
UBOOT="-u-boot.img"

BINFILE=""
SPLFILE=""
UBOOTFILE=""

if [ -L $UUU ]
then
    rm -rf ./$UUU
fi

if [ -f $FLASHCODE ]
then
    rm -rf ./$FLASHCODE
fi

PWD="$(echo ~)"
#make uuu_file symbolink to uuu file
ln -s "$PWD$IMX_UUU_TOOL$UUU_DST" "$UUU"

SOCID=$(SOCNameFinder $EMMCIMAGE)
echo $SOCID

SOMID=$(SOMNameFinder $EMMCIMAGE)
echo $SOMID


case $SOCID in
  imx8mm|imx8mp|imx8mn|imx8mq)
    EMMCSCRIPT="emmc_img"
    BINFILE=$PWD$IMX_UUU_TOOL/$SOCID/$SOMID/$SOMID$BOARDTYPE_Tail
    SPLFILE=""
    UBOOTFILE=""
    ;;
  imx6)
    EMMCSCRIPT="emmc_imx6_img"
    BINFILE=""
    SPLFILE=$PWD$IMX_UUU_TOOL/$SOCID/$SOMID/$SOMID$SPL
    UBOOTFILE=$PWD$IMX_UUU_TOOL/$SOCID/$SOMID/$SOMID$UBOOT
    ;;
  imx6ul)
    EMMCSCRIPT="emmc_imx6_img"
    BINFILE=""
    SPLFILE=$PWD$IMX_UUU_TOOL/$SOCID/$SOMID/$SOMID$SPL
    UBOOTFILE=$PWD$IMX_UUU_TOOL/$SOCID/$SOMID/$SOMID$UBOOT
    ;;
  imx7)
    EMMCSCRIPT="emmc_imx7_img"
    BINFILE=""
    SPLFILE=$PWD$IMX_UUU_TOOL/$SOCID/$SOMID/$SOMID$SPL
    UBOOTFILE=$PWD$IMX_UUU_TOOL/$SOCID/$SOMID/$SOMID$UBOOT
    ;;
esac

readlink $UUU
echo $EMMCSCRIPT
echo $BINFILE
echo $SPLFILE
echo $UBOOTFILE
echo $EMMCIMAGE

# Generate uuu flash script

cat <<EOF >>$FLASHCODE
#!/bin/bash

EMMCSCRIPT=$EMMCSCRIPT
BINFILE=$BINFILE
SPLFILE=$SPLFILE
UBOOTFILE=$UBOOTFILE
EMMCIMAGE=$EMMCIMAGE

echo "Script description :"
echo "$UUU -d -b $EMMCSCRIPT $BINFILE $SPLFILE $UBOOTFILE $EMMCIMAGE"
echo
echo "command perform ..."
echo
sudo ./$UUU -d -b $EMMCSCRIPT $BINFILE $SPLFILE $UBOOTFILE $EMMCIMAGE
EOF

sudo chmod +x $FLASHCODE
