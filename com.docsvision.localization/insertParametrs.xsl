<dummy xmlns:dita="http://dita-ot.sourceforge.net" xmlns:if="ant:if" xmlns:unless="ant:unless">
	<param name="DEFAULTLANG" expression="${lang}" if:set="lang"/>
	<param name="DEFAULTLANG" value="ru" unless:set="lang"/>
</dummy>