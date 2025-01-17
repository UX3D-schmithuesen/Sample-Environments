#!/usr/bin/env bash

CLI=${CLI:-"./cli"}

# Loop over all .hdr files in the current directory
for hdrFile in *_sd.hdr
do
  # Remove the file extension to form a directory name
  # e.g. "myImage.hdr" -> "myImage"
  baseName="${hdrFile%.*}"
  CurDir="${baseName}/"

  echo "Processing: $hdrFile"
  echo "Output directory: $CurDir"

  # Create the main folder and subfolders
  mkdir -p "$CurDir/lambertian"
  mkdir -p "$CurDir/ggx"
  mkdir -p "$CurDir/charlie"

  # Set output paths
  outputPathLambertian="${CurDir}lambertian/diffuse.ktx2"
  outputPathGgx="${CurDir}ggx/specular.ktx2"
  outputPathCharlie="${CurDir}charlie/sheen.ktx2"

  # Run commands for each distribution
  ${CLI} -inputPath "$hdrFile" -distribution Lambertian -outCubeMap "$outputPathLambertian"
  ${CLI} -inputPath "$hdrFile" -distribution GGX        -outCubeMap "$outputPathGgx"        -mipLevelCount 11 -lodBias 0
  ${CLI} -inputPath "$hdrFile" -distribution Charlie    -outCubeMap "$outputPathCharlie"    -mipLevelCount 11 -lodBias 0

  echo "Done with $hdrFile"
  echo

done
