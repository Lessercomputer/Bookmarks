FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        l     �� 	 
��   	 M GopenURLsInSafari({"http://www.apple.com/jp/", "http://www.apple.com/"})    
 �   � o p e n U R L s I n S a f a r i ( { " h t t p : / / w w w . a p p l e . c o m / j p / " ,   " h t t p : / / w w w . a p p l e . c o m / " } )      l    
 ����  I     
�� ���� :0 openurlsinsafariwithnewtabs openURLsInSafariWithNewTabs   ��  J           m       �   0 h t t p : / / w w w . g o o g l e . c o . j p /      m       �   0 h t t p : / / w w w . a p p l e . c o m / j p /   ��  m       �   * h t t p : / / w w w . a p p l e . c o m /��  ��  ��  ��  ��        l     ��   ��    4 .openURLsInSafari({"http://www.apple.com/jp/"})      � ! ! \ o p e n U R L s I n S a f a r i ( { " h t t p : / / w w w . a p p l e . c o m / j p / " } )   " # " l     ��������  ��  ��   #  $ % $ i      & ' & I      �� (���� $0 openurlsinsafari openURLsInSafari (  )�� ) o      ���� 0 aurls aURLs��  ��   ' k      * *  + , + l      �� - .��   -��tell application "Safari"
		activate
		if not (exists documents) then make new document
		
		tell window 1
			set aStartIndex to index of current tab
			repeat with i from aStartIndex to count of aURLs
				if exists tab i then
					set URL of tab i to item i of aURLs
				else
					make new tab with properties {URL:item i of aURLs}
				end if
			end repeat
			set current tab to tab aStartIndex
		end tell
		
	end tell    . � / /F t e l l   a p p l i c a t i o n   " S a f a r i " 
 	 	 a c t i v a t e 
 	 	 i f   n o t   ( e x i s t s   d o c u m e n t s )   t h e n   m a k e   n e w   d o c u m e n t 
 	 	 
 	 	 t e l l   w i n d o w   1 
 	 	 	 s e t   a S t a r t I n d e x   t o   i n d e x   o f   c u r r e n t   t a b 
 	 	 	 r e p e a t   w i t h   i   f r o m   a S t a r t I n d e x   t o   c o u n t   o f   a U R L s 
 	 	 	 	 i f   e x i s t s   t a b   i   t h e n 
 	 	 	 	 	 s e t   U R L   o f   t a b   i   t o   i t e m   i   o f   a U R L s 
 	 	 	 	 e l s e 
 	 	 	 	 	 m a k e   n e w   t a b   w i t h   p r o p e r t i e s   { U R L : i t e m   i   o f   a U R L s } 
 	 	 	 	 e n d   i f 
 	 	 	 e n d   r e p e a t 
 	 	 	 s e t   c u r r e n t   t a b   t o   t a b   a S t a r t I n d e x 
 	 	 e n d   t e l l 
 	 	 
 	 e n d   t e l l ,  0�� 0 I     �� 1���� :0 openurlsinsafariwithoptions openURLsInSafariWithOptions 1  2 3 2 o    ���� 0 aurls aURLs 3  4 5 4 m    ����   5  6�� 6 m    ����  ��  ��  ��   %  7 8 7 l     ��������  ��  ��   8  9 : 9 i     ; < ; I      �� =���� :0 openurlsinsafariwithnewtabs openURLsInSafariWithNewTabs =  >�� > o      ���� 0 aurls aURLs��  ��   < k      ? ?  @ A @ l      �� B C��   B$tell application "Safari"
		activate
		if not (exists documents) then make new document
		
		tell window 1
			set anIndex to (count tabs) + 1
			repeat with aURL in aURLs
				make new tab with properties {URL:aURL}
			end repeat
			set current tab to tab anIndex
		end tell
		
	end tell    C � D D< t e l l   a p p l i c a t i o n   " S a f a r i " 
 	 	 a c t i v a t e 
 	 	 i f   n o t   ( e x i s t s   d o c u m e n t s )   t h e n   m a k e   n e w   d o c u m e n t 
 	 	 
 	 	 t e l l   w i n d o w   1 
 	 	 	 s e t   a n I n d e x   t o   ( c o u n t   t a b s )   +   1 
 	 	 	 r e p e a t   w i t h   a U R L   i n   a U R L s 
 	 	 	 	 m a k e   n e w   t a b   w i t h   p r o p e r t i e s   { U R L : a U R L } 
 	 	 	 e n d   r e p e a t 
 	 	 	 s e t   c u r r e n t   t a b   t o   t a b   a n I n d e x 
 	 	 e n d   t e l l 
 	 	 
 	 e n d   t e l l A  E�� E I     �� F���� :0 openurlsinsafariwithoptions openURLsInSafariWithOptions F  G H G o    ���� 0 aurls aURLs H  I J I m    ������ J  K�� K m    ��������  ��  ��   :  L M L l     ��������  ��  ��   M  N�� N i     O P O I      �� Q���� :0 openurlsinsafariwithoptions openURLsInSafariWithOptions Q  R S R o      ���� 0 aurls aURLs S  T U T o      ����  0 astarttabindex aStartTabIndex U  V�� V o      ���� &0 atabindextoselect aTabIndexToSelect��  ��   P O     � W X W k    � Y Y  Z [ Z I   	������
�� .miscactvnull��� ��� null��  ��   [  \ ] \ Z  
   ^ _���� ^ H   
  ` ` l  
  a���� a I  
 �� b��
�� .coredoexbool       obj  b 2  
 ��
�� 
docu��  ��  ��   _ I   ���� c
�� .corecrel****      � null��   c �� d��
�� 
kocl d m    ��
�� 
docu��  ��  ��   ]  e f e r   ! ' g h g 4   ! %�� i
�� 
cwin i m   # $����  h o      ���� 0 atargetwindow aTargetWindow f  j�� j O   ( � k l k k   , � m m  n o n Z   , S p q r s p =   , / t u t o   , -����  0 astarttabindex aStartTabIndex u m   - .����   q r   2 9 v w v n   2 7 x y x 1   5 7��
�� 
pidx y 1   2 5��
�� 
cTab w o      ���� 0 	atabindex 	aTabIndex r  z { z =   < ? | } | o   < =����  0 astarttabindex aStartTabIndex } m   = >������ {  ~�� ~ r   B M  �  [   B K � � � l  B I ����� � I  B I�� ���
�� .corecnte****       **** � 2  B E��
�� 
bTab��  ��  ��   � m   I J����  � o      ���� 0 	atabindex 	aTabIndex��   s r   P S � � � o   P Q����  0 astarttabindex aStartTabIndex � o      ���� 0 	atabindex 	aTabIndex o  � � � l  T T��������  ��  ��   �  � � � Z   T q � � ��� � =   T W � � � o   T U���� &0 atabindextoselect aTabIndexToSelect � m   U V����   � r   Z a � � � n   Z _ � � � 1   ] _��
�� 
pidx � 1   Z ]��
�� 
cTab � o      ���� &0 atabindextoselect aTabIndexToSelect �  � � � =   d g � � � o   d e���� &0 atabindextoselect aTabIndexToSelect � m   e f������ �  ��� � r   j m � � � o   j k���� 0 	atabindex 	aTabIndex � o      ���� &0 atabindextoselect aTabIndexToSelect��  ��   �  � � � l  r r��������  ��  ��   �  � � � Y   r � ��� � ��� � k   � � � �  � � � Z   � � � ��� � � I  � ��� ���
�� .coredoexbool       obj  � 4   � ��� �
�� 
bTab � o   � ����� 0 	atabindex 	aTabIndex��   � r   � � � � � n   � � � � � 4   � ��� �
�� 
cobj � o   � ����� 0 anindexinurls anIndexInURLs � o   � ����� 0 aurls aURLs � n       � � � 1   � ���
�� 
pURL � 4   � ��� �
�� 
bTab � o   � ����� 0 	atabindex 	aTabIndex��   � k   � � � �  � � � l  � ��� � ���   � D >make new tab with properties {URL:item anIndexInURLs of aURLs}    � � � � | m a k e   n e w   t a b   w i t h   p r o p e r t i e s   { U R L : i t e m   a n I n d e x I n U R L s   o f   a U R L s } �  ��� � r   � � � � � n   � � � � � 4   � ��� �
�� 
cobj � o   � ����� 0 anindexinurls anIndexInURLs � o   � ����� 0 aurls aURLs � n       � � � 1   � ���
�� 
pURL � l  � � ����� � I  � ����� �
�� .corecrel****      � null��   � � ��~
� 
kocl � m   � ��}
�} 
bTab�~  ��  ��  ��   �  � � � l  � ��|�{�z�|  �{  �z   �  ��y � r   � � � � � [   � � � � � o   � ��x�x 0 	atabindex 	aTabIndex � m   � ��w�w  � o      �v�v 0 	atabindex 	aTabIndex�y  �� 0 anindexinurls anIndexInURLs � m   u v�u�u  � I  v {�t ��s
�t .corecnte****       **** � o   v w�r�r 0 aurls aURLs�s  ��   �  � � � l  � ��q�p�o�q  �p  �o   �  ��n � r   � � � � � 4   � ��m �
�m 
bTab � o   � ��l�l &0 atabindextoselect aTabIndexToSelect � 1   � ��k
�k 
cTab�n   l o   ( )�j�j 0 atargetwindow aTargetWindow��   X m      � ��                                                                                  sfri  alis    N  Macintosh HD               �5��H+     Y
Safari.app                                                       I�.�        ����  	                Applications    �57�      ��T       Y  %Macintosh HD:Applications: Safari.app    
 S a f a r i . a p p    M a c i n t o s h   H D  Applications/Safari.app   / ��  ��       �i � � � � ��i   � �h�g�f�e�h $0 openurlsinsafari openURLsInSafari�g :0 openurlsinsafariwithnewtabs openURLsInSafariWithNewTabs�f :0 openurlsinsafariwithoptions openURLsInSafariWithOptions
�e .aevtoappnull  �   � **** � �d '�c�b � ��a�d $0 openurlsinsafari openURLsInSafari�c �` ��`  �  �_�_ 0 aurls aURLs�b   � �^�^ 0 aurls aURLs � �]�] :0 openurlsinsafariwithoptions openURLsInSafariWithOptions�a 	*�jjm+   � �\ <�[�Z � ��Y�\ :0 openurlsinsafariwithnewtabs openURLsInSafariWithNewTabs�[ �X ��X  �  �W�W 0 aurls aURLs�Z   � �V�V 0 aurls aURLs � �U�U :0 openurlsinsafariwithoptions openURLsInSafariWithOptions�Y 	*�iim+   � �T P�S�R � ��Q�T :0 openurlsinsafariwithoptions openURLsInSafariWithOptions�S �P ��P  �  �O�N�M�O 0 aurls aURLs�N  0 astarttabindex aStartTabIndex�M &0 atabindextoselect aTabIndexToSelect�R   � �L�K�J�I�H�G�L 0 aurls aURLs�K  0 astarttabindex aStartTabIndex�J &0 atabindextoselect aTabIndexToSelect�I 0 atargetwindow aTargetWindow�H 0 	atabindex 	aTabIndex�G 0 anindexinurls anIndexInURLs �  ��F�E�D�C�B�A�@�?�>�=�<�;
�F .miscactvnull��� ��� null
�E 
docu
�D .coredoexbool       obj 
�C 
kocl
�B .corecrel****      � null
�A 
cwin
�@ 
cTab
�? 
pidx
�> 
bTab
�= .corecnte****       ****
�< 
cobj
�; 
pURL�Q �� �*j O*�-j  *��l Y hO*�k/E�O� ��j  *�,�,E�Y �i  *�-j 
kE�Y �E�O�j  *�,�,E�Y �i  �E�Y hO ?k�j 
kh *�/j  ��/*�/�,FY ��/*��l �,FO�kE�[OY��O*�/*�,FUU � �: ��9�8 � ��7
�: .aevtoappnull  �   � **** � k     
 � �  �6�6  �9  �8   �   �    �5�5 :0 openurlsinsafariwithnewtabs openURLsInSafariWithNewTabs�7 *���mvk+  ascr  ��ޭ