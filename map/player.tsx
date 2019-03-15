<?xml version="1.0" encoding="UTF-8"?>
<tileset name="player" tilewidth="32" tileheight="32" tilecount="9" columns="3">
 <image source="playersprtmp.png" width="96" height="96"/>
 <tile id="0">
  <properties>
   <property name="isPlayer" type="bool" value="true"/>
   <property name="sprite" value="map/playersprtmp.png"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="8" y="4" width="16" height="28"/>
  </objectgroup>
 </tile>
 <tile id="6">
  <objectgroup draworder="index">
   <object id="1" x="24" y="8" width="8" height="20"/>
  </objectgroup>
 </tile>
</tileset>
