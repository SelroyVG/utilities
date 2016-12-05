<?php
	// This script converts CSV-file to a simple XML-table.
	// http://egor.dev.slizatest.code-geek.ru/convert_csv.php
	// GET-parameters:
	// url — URL of your CSV-file
	// encoding — original encoding of the CSV-file (use it only if original encoding is NOT utf-8)
	
	$csv_handle = fopen($_GET["url"], "r");
	
	if (isset($_GET["encoding"])){
		$encoding = $_GET["encoding"];
	}
	
	$dom = new domDocument("1.0", "utf-8");
	$root = $dom->createElement("table");
	$dom->appendChild($root);
	$root->setAttribute("border", "1");
	$flag = 0;
	while(!feof($csv_handle)){
		$tr = $dom->createElement("tr");
		$root->appendChild($tr);
		
		$csv_string = fgets($csv_handle);
		
		$csv_string = mb_convert_encoding($csv_string, 'utf-8', $encoding);
		if(preg_match('/;+"[^;"]*$/u', $csv_string)){
			$add_string = "string";
			do{
				$add_string = fgets($csv_handle);
				$add_string = mb_convert_encoding($add_string, "UTF-8", $encoding);
				$csv_string = $csv_string . $add_string;
			}while( (!preg_match('/^[^;"]*"/u', $add_string) or preg_match('/^[^;"]*";+"[^;"]*$/u', $add_string)) and (!feof($csv_handle)) );
		}
		
		$array_csv_string = explode(";", $csv_string);
		foreach ($array_csv_string as &$table_cell){
			$td = $dom->createElement("td", $table_cell);
			$tr->appendChild($td);
			
		}
	}
	fclose($csv_handle);
	
	echo $dom->saveXML();
?>