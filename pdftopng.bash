main () {
	{
		local pdfPath="$1"
		local pdfSize
		pdfSize=$(pdfinfo "$pdfPath" | awk '/Pages:/ {print $2}')
	}
	{
		local nPdfSizeDigits=${#pdfSize}
		for pdfPage in $(seq 1 "$pdfSize"); do
			local nPdfPageDigits=${#pdfPage}
			local nPdfPageZeroes=$((nPdfSizeDigits - nPdfPageDigits))
			local pdfPageNormalized
			pdfPageNormalized=$(
				for i in $(seq 1 $nPdfPageZeroes); do
					echo -n 0
				done
				echo -n $pdfPage
			)
			echo -en "[$pdfPageNormalized/$pdfSize] converting..."
			pdftoppm "$pdfPath" \
				-png \
				-r 300 \
				-singlefile \
				-f "$pdfPage" \
				"$pdfPath-$pdfPageNormalized"
			touch "$pdfPath-$pdfPageNormalized.png" 
			echo -en "Done.\n"
		done
	}
}

main "$@"
