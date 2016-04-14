<!doctype html>
<html>
<head>
<meta charset="<?php echo htmlspecialchars(Wekit::V('charset'), ENT_QUOTES, 'UTF-8');?>">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title><?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','c','name'), ENT_QUOTES, 'UTF-8');?></title>
<link href="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','css'), ENT_QUOTES, 'UTF-8');?>/admin_style.css?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>" rel="stylesheet" />
<script>
//全局变量，是Global Variables不是Gay Video喔
var GV = {
	JS_ROOT : "<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','res'), ENT_QUOTES, 'UTF-8');?>/js/dev/",																									//js目录
	JS_VERSION : "<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>",																										//js版本号
	TOKEN : '<?php echo htmlspecialchars(Wind::getComponent('windToken')->saveToken('csrf_token'), ENT_QUOTES, 'UTF-8');?>',	//token ajax全局
	REGION_CONFIG : {},
	SCHOOL_CONFIG : {},
	URL : {
		LOGIN : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','loginUrl'), ENT_QUOTES, 'UTF-8');?>',																													//后台登录地址
		IMAGE_RES: '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','images'), ENT_QUOTES, 'UTF-8');?>',																										//图片目录
		REGION : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=area'; ?>',					//地区
		SCHOOL : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=school'; ?>'				//学校
	}
};
</script>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/wind.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/jquery.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>

</head>
<body>
<div class="wrap">
	<div class="nav">
		<div class="return"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=u&c=manage'; ?>">返回上一级</a></div>
		<ul class="cc">
			<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?uid=', rawurlencode($uid),'&m=u&c=manage&a=edit'; ?>">用户信息</a></li>
			<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?uid=', rawurlencode($uid),'&m=u&c=manage&a=editCredit'; ?>">积分</a></li>
			<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?uid=', rawurlencode($uid),'&m=u&c=manage&a=editGroup'; ?>">用户组</a></li>
		</ul>
	</div>
<!--====================用户编辑开始====================-->
<!--用户组-->
<div class="h_a">编辑用户组</div>
<form class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=u&c=manage&a=doEditGroup'; ?>" method="post">
<input type="hidden" value="<?php echo htmlspecialchars($uid, ENT_QUOTES, 'UTF-8');?>" name="uid" >
<input type="hidden" value="<?php echo htmlspecialchars($showtype, ENT_QUOTES, 'UTF-8');?>" name="showtype" >
<div class="table_full">
	<table width="100%">
		<col class="th" />
		<col width="400" />
		<col />
		<thead>
		<tr>
			<th>用户名</th>
			<td><span class="mr10"><?php echo htmlspecialchars($username, ENT_QUOTES, 'UTF-8');?></span> (UID：<?php echo htmlspecialchars($uid, ENT_QUOTES, 'UTF-8');?>)</td>
			<td><div class="fun_tips"></div></td>
		</tr>
		</thead>
		<tr>
			<th>默认用户组</th>
			<td>
				<select id="J_u_group_select" class="select_5" name="groupid">
					<?php  foreach ($allGroups as $item) { ?>
					<option value="<?php echo htmlspecialchars($item['gid'], ENT_QUOTES, 'UTF-8');?>"<?php echo htmlspecialchars(Pw::isSelected($info['groupid'] == $item['gid']), ENT_QUOTES, 'UTF-8');?>><?php echo htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8');?></option>
					<?php  } ?>
					<option value="0"<?php echo htmlspecialchars(Pw::isSelected($info['groupid'] == 0), ENT_QUOTES, 'UTF-8');?>>普通组</option>
				</select>
			</td>
			<td><div class="fun_tips">用户默认的用户组，注意：如果拥有用户组中设置了附加组，默认用户组会根据系统默认用户组优先级重新计算当前的用户组。</div></td>
		</tr>
		<tfoot>
		<tr>
			<th>拥有用户组</th>
			<td>
				<div class="cross">
					<ul id="J_u_group_default">
						<li>
							<span class="span_3">用户组</span>
							<span class="span_3">到期时间</span>
						</li>
						<?php 
						$myGids = array_keys($userGroups);
						foreach ($allGroups as $item) {
								if (Pw::inArray($item['gid'], $defaultGroups)) continue;
								$check = $canCheck = '';;
								$disabled = 'disabled=disabled';
								$disableclass = 'disabled';
								if (Pw::inArray($item['gid'], $myGids)) {
									$check = 'checked=checked';
									$disabled = $disableclass = '';
								}
								if (Pw::inArray($info['groupid'], $defaultGroups)) {
									$canCheck = 'disabled=disabled';
								}
								$endtime = $userGroups[$item['gid']]['endtime'] ? Pw::time2Str($userGroups[$item['gid']]['endtime'], 'Y-m-d H:i') : '';
						?>
						<li>
							<span class="span_3"><label><input name="groups[]" <?php echo htmlspecialchars($canCheck, ENT_QUOTES, 'UTF-8');?> type="checkbox" class="checkbox J_group_check" id="J_check_<?php echo htmlspecialchars($item['gid'], ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($item['gid'], ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars($check, ENT_QUOTES, 'UTF-8');?>><?php echo htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8');?></label></span>
							<span class="span_3"><input name="endtime[<?php echo htmlspecialchars($item['gid'], ENT_QUOTES, 'UTF-8');?>]" <?php echo htmlspecialchars($disabled, ENT_QUOTES, 'UTF-8');?> type="text" class="input length_2 <?php echo htmlspecialchars($disableclass, ENT_QUOTES, 'UTF-8');?> J_date J_group_input" id="J_input_<?php echo htmlspecialchars($item['gid'], ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($endtime, ENT_QUOTES, 'UTF-8');?>"></span>
						</li>
						<?php  } ?>
						<!--普通组-->
						<li>
							<span class="span_3"><label><input name="" type="checkbox" class="checkbox" value="0" checked='checked'  disabled="disabled">普通组</label></span>
							<span class="span_3"><input name="" type="text" class="input length_2 input_disabled disabled" disabled="disabled" value="0"></span>
						</li>
					</ul>
				</div>
			</td>
			<td><div class="fun_tips">设置用户拥有的用户组，通过到期时间，可以控制用户拥有该用户组的时间，到期后系统自动取消对应用户组。</div></td>
		</tr>
		</tfoot>
	</table>
</div>
<div class="btn_wrap">
	 <div class="btn_wrap_pd">
			<button type="submit" class="btn btn_submit J_ajax_submit_btn">提交</button>
	 </div>
</div>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>



</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script>
$(function(){
	//选择默认用户组
	$('#J_u_group_select').change(function(){
		var select_val = $(this).val();
		
		if(select_val === '7' || select_val === '6') {
			//禁止发言和未验证会员，先取消所有状态
			$('input.J_group_check').prop({
				'disabled': true,
				'checked' : false
			});
			$('input.J_group_input').prop('disabled', true).addClass('disabled');
		}else{
			//所有check开启
			$('input.J_group_check').prop({
				'disabled': false
			});

			//取消禁止发言和未验证会员
			/* $('#J_check_7, #J_check_6').prop({
				'disabled': true,
				'checked' : false
			});
			$('#J_input_7, #J_input_6').prop('disabled', true).addClass('disabled'); */
		}
		checkSingle(select_val);

	});

	function checkSingle(v){
		$('#J_check_'+ v).prop({
			'disabled': false,
			'checked': true
		});
		$('#J_input_'+ v).prop('disabled', false).removeClass('disabled');
	}
	
	//点击拥有用户组
	$('input.J_group_check').change(function(){
		var $this = $(this), change_input = $('#J_input_'+ $this.val());
		if($this.prop('checked')) {
			change_input.prop('disabled', false).removeClass('disabled');
		}else{
			change_input.prop('disabled', true).addClass('disabled');
		}
	});
});
</script>
</body>
</html>