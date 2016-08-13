<%@ page import="cland.membership.SystemRoles" %>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>

<div id="tab-2">
				
					<table class="inner-table">
						<thead>
							<tr>
								<th>Name</th>
								<th>Date</th>
								<th>Time-in</th>
								<th>Time-out</th>
								<th>Duration</th>
								<th>Contact No.</th>
								<th>Status</th>	
								<th>Selected Hours</th>
								<th>Wrist Band No.</th>
								<th>Actions</th>							
							</tr>
						</thead>
						
							<g:each in="${visitsList}" var="v">
								<tr>
									<td><g:link controller="child" action="show" id="${v?.child?.id}">${v?.child?.person }</g:link></td>						
									<td>${v?.starttime?.format("dd MMM yyyy")}</td>
									<td>${v?.starttime?.format("hh:mm")}</td>
									<td>${v?.endtime?.format("HH:mm")}</td>
									<td>${v?.durationText}</td>
									<td>${v?.contactNo}</td>
									<td id="row-visit-status-${c?.id}" class="status-${v?.status }">${v?.status}</td>									
									<td>
										${v?.visitNo }																
									</td>
									<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
										<td>
											<g:if test="${v?.status?.equalsIgnoreCase('Complete')}">
												<asset:image src="skin/icon_cross.png" class="rm-visit-icon" onClick="setVisitStatus('${v?.id }','Cancelled');return false;" id="rm-visit-${v?.id }" title="Cancel this visit!" alt="Cancel this visit!"/>
												&nbsp;<asset:image src="skin/database_add.png" class="add-couponvisit-icon" onClick="addVisitToCoupon('${v?.id }');" id="add_couponvisit_${v?.id }" title="Add this visit to coupon" alt="Add this visit to coupon!"/>
											</g:if>
											<asset:image src="spinner.gif" class="spinner-rmvisit-wait hide" id="spinner-rmvisit-wait-${v?.id }" title="Processing, please wait..." alt="Processing, please wait...!"/>
										</td>
									</sec:ifAnyGranted>
								</tr>
							</g:each>
						
					</table>
				
			</div>