#一些好玩的category


###1.第一个FlashEffect，仿照谷歌原生效果

###2.第二个Luhn算法在NSString中的封装，用来校验银行卡号是否合法

```
	关于luhn算法的校验规则，16位银行卡号（16-19位通用）:
		1.将未带校验位的 15（或18）位卡号从右依次编号 1 到 15（18），位于奇数位号上的数字乘以 2。
		2.将奇位乘积的个十位全部相加，再加上所有偶数位上的数字。
		3.将加法和加上校验位能被 10 整除。

	将测试可以正常使用。
```
