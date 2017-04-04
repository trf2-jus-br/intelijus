var app = angular.module('app', [ 'googlechart', 'angularModalService',
		'ngAnimate', 'ngRoute', 'cgBusy' ]);

app.config([ '$routeProvider', '$locationProvider',
		function($routeProvider, $locationProvider) {
			$routeProvider.when('/home', {
				templateUrl : 'resources/home.html',
				controller : 'ctrl'
			}).when('/sugestoes', {
				templateUrl : 'resources/sugestoes.html',
				controller : 'ctrlSugerir'
			}).when('/pivot', {
				templateUrl : 'resources/pivot.html',
				controller : 'pivotCtrl'
			}).when('/sobre', {
				templateUrl : 'resources/sobre.html',
				controller : 'ctrlSobre'
			}).otherwise({
				redirectTo : '/home'
			});
			// enable html5Mode for pushstate ('#'-less URLs)
			$locationProvider.html5Mode(false);
		} ]);

app
		.controller(
				'routerCtrl',
				function($scope, $http, $window, $q, $location, $timeout) {
					$scope.promise = [];

					$scope.urlBaseAPI = "./api/v1";

					$scope.isActive = function(viewLocation) {
						return viewLocation === $location.path();
					};

					$scope.parseLocation = function(location) {
						var pairs = location.substring(1).split("&");
						var obj = {};
						var pair;
						var i;

						for (i in pairs) {
							if (pairs[i] === "")
								continue;

							var idx = pairs[i].indexOf("=");
							obj[decodeURIComponent(pairs[i].substring(0, idx))] = decodeURIComponent(pairs[i]
									.substring(idx + 1));
						}

						return obj;
					};

					$scope.init = function() {
						$scope.promise = [];
						$scope.promise
								.push($http({
									url : $scope.urlBaseAPI + "/orgaos",
									method : "GET"
								})
										.then(
												function successCallback(
														response) {
													var data = response.data;
													$scope.orgaos = data.list;
													if ($scope.orgaos.length == 1)
														$scope
																.selecionarOrgao($scope.orgaos[0].codigo);
												},
												function errorCallback(response) {
												}));
					}

					$scope.selecionarOrgao = function(codigo) {
						$scope.orgaoSelecionado = codigo;
						if (!codigo) {
							delete $scope.unidades;
						}
						$scope.selecionarUnidade();
						$scope.promise = [];
						$scope.promise
								.push($http(
										{
											url : $scope.urlBaseAPI + "/orgao/"
													+ codigo + "/unidades",
											method : "GET"
										})
										.then(
												function successCallback(
														response) {
													var data = response.data;
													$scope.unidades = data.list;
													if ($scope.unidades.length == 1)
														$scope
																.selecionarUnidade($scope.unidades[0].codigo);
												},
												function errorCallback(response) {
												}));
					}

					$scope.selecionarUnidade = function(codigo) {
						$scope.unidadeSelecionada = codigo;
					}

					$scope
							.$watch(
									function() {
										return $scope.unidadeSelecionada;
									},
									function() {
										$scope.tituloUnidadeSelecionada = (($scope.unidades || [])
												.find(function(e) {
													return e.codigo === $scope.unidadeSelecionada
												}) || {}).descricao;
									});

					$timeout($scope.init, 10);

					$scope.querystring = $scope
							.parseLocation($window.location.search);

				});

// Sugestoes
app.controller('ctrlSugerir', function($scope, $http, $templateCache,
		$interval, $window, ModalService) {
	$scope.fdSugerir = function() {
		if (!$scope.sugestao)
			return "";
		var obj = {
			nome : $scope.sugestao.nome,
			email : $scope.sugestao.email,
			// orgao : (($scope.$parent.orgaos || []).find(function(e) {
			// return e.codigo === $scope.$parent.orgaoSelecionado
			// }) || {}).nome,
			// unidade : (($scope.$parent.unidades || []).find(function(e) {
			// return e.codigo === $scope.$parent.unidadeSelecionada
			// }) || {}).nome,
			mensagem : $scope.sugestao.mensagem
		};
		return formdata(obj);
	}

	$scope.sugerir = function() {
		$scope.$parent.promise = [];
		$scope.$parent.promise.push($http({
			url : $scope.urlBaseAPI + '/sugestao',
			method : "POST",
			data : $scope.fdSugerir(),
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).success(
				function(data, status, headers, config) {
					$scope.message("Sucesso",
							"Sua mensagem foi enviada. Muito obrigado!");
					$scope.sugestao = {};
				}).error(function(data, status, headers, config) {
			$scope.message("Erro", data.errormsg);
		}));

		$scope.message = function(title, message) {
			ModalService.showModal({
				templateUrl : "resources/dialog-message.html",
				controller : "DismissController",
				inputs : {
					title : title,
					message : message
				}
			}).then(function(modal) {
				modal.element.modal();
			});
		};

	}

});

// Sugestoes
app.controller('ctrlSobre', function($scope) {
});

app.controller('pivotCtrl', function($scope, $http, $templateCache) {
	$scope.pivotCreate = function() {
		var weekday = [ "Dom", "2a", "3a", "4a", "5a", "6a", "Sáb" ];
		var dateFormat = $.extend($.pivotUtilities.derivers.dateFormat);
		var renderers = $.pivotUtilities.renderers;
		var gchart_renderers = $.pivotUtilities.gchart_renderers

		conf = {
			aggregatorName : 'Sum',
			vals : [ 'quantidade' ],
			rendererName : 'Stacked Bar Chart',
			rows : [ 'tipoMovimentacao' ],
			cols : [ 'ano' ]
		};
		$("#pivot").pivotUI($scope.data, {
			renderers : $.extend(renderers, gchart_renderers),
			aggregatorName : conf.aggregatorName,
			vals : conf.vals,
			rendererName : conf.rendererName,
			cols : conf.cols,
			rows : conf.rows,
			derivedAttributes : {},
			hiddenAttributes : [],
			aggregators2 : {},
			onRefresh : function(config) {
				var config_copy = JSON.parse(JSON.stringify(config));
				// delete some values which are functions
				delete config_copy["aggregators"];
				delete config_copy["renderers"];
				delete config_copy["derivedAttributes"];
				// delete some bulky default values
				delete config_copy["rendererOptions"];
				delete config_copy["localeStrings"];
				localStorage.setItem('pivot', config_copy)
				// $scope.$apply();
			}
		});

		$("#pivot table:first-child").css("width", "100%");
	}

	$scope.fetchEstatisticas = function() {
		$scope.response = null;
		$scope.carregando = true;
		$scope.promise = ($http({
			method : "GET",
			url : "api/v1/relatorio/dinamico"
		}).success(function(data, status) {
			$scope.carregando = false;
			$scope.data = data.list;
			if (!google.visualization) {
				google.load("visualization", "1", {
					packages : [ "corechart", "charteditor" ],
					callback : $scope.pivotCreate
				});
			} else {
				$scope.pivotCreate();
			}
		}).error(function(data, status) {
			$scope.carregando = false;
			delete $scope.data;
			alert("erro buscando linhas do relatório dinâmico.");
		}));
	};

	$scope.fetchEstatisticas();

});

app.controller('DismissController', function($scope, title, message, close) {
	$scope.title = title;
	$scope.message = message;

	$scope.dismissModal = function(result) {
		close(result, 200);
	};

});

app
		.controller(
				'ctrl',
				function($scope, $http, $interval, $window, $location, $filter,
						$timeout, $routeParams, ModalService) {
					$scope.gauges = {};
					$scope.countGauges = 0;
					$scope.updatingGauges = true;
					$scope.countGaugesMetaEspecifica = 0;
					$scope.updatingGaugesMetaEspecifica = true;

					$scope.$watch(function() {
						return $scope.$parent.unidadeSelecionada;
					}, function() {
						console.log("Alterado: ",
								$scope.$parent.unidadeSelecionada);
						$scope.update();
					});

					$scope.update = function() {
						var unidade = $scope.$parent.unidadeSelecionada;

						$scope.countGauges = 0;
						$scope.updatingGauges = true;
						// $scope.countGaugesMetaEspecifica = 1;
						$scope.updatingGaugesMetaEspecifica = true;
						for (var i = 1; i <= 6; i++)
							$scope.drawGauge('meta' + i, "&nbsp;", -1, null,
									null);
						for (var i = 1; i <= 3; i++)
							$scope.drawGauge('metaespecifica' + i, "&nbsp;",
									-1, null, null);

						$scope.updatePieChart($scope.acervoChart.data);
						$scope.updateColumnChart($scope.documentosChart);
						$scope.updatePieChart($scope.pendenciasChart.data);
						// $scope.updatePieChart($scope.metasChart.data);

						if (!unidade) {
							return;
						}

						var urlBase = $scope.urlBaseAPI + "/orgao/"
								+ $scope.$parent.orgaoSelecionado + "/unidade/"
								+ $scope.$parent.unidadeSelecionada;

						$scope.$parent.promise = [];

						$scope.$parent.promise.push($http({
							url : urlBase + "/acervo",
							method : "GET"
						}).then(
								function successCallback(response) {
									$scope.updatePieChart(
											$scope.acervoChart.data,
											response.data.list);
								}, function errorCallback(response) {
								}));

						$scope.$parent.promise.push($http({
							url : urlBase + "/producao",
							method : "GET"
						}).then(
								function successCallback(response) {
									// $scope.updatePieChart(
									// $scope.documentosChart.data,
									// response.data.list);

									$scope.updateColumnChart(
											$scope.documentosChart,
											response.data.list);
								}, function errorCallback(response) {
								}));

						$scope.$parent.promise.push($http({
							url : urlBase + "/pendencias",
							method : "GET"
						}).then(
								function successCallback(response) {
									$scope.updatePieChart(
											$scope.pendenciasChart.data,
											response.data.list);
								}, function errorCallback(response) {
								}));

						$scope.$parent.promise.push($http({
							url : urlBase + "/metas/nacionais",
							method : "GET"
						}).then(
								function successCallback(response) {
									var l = response.data.list;
									$scope.countGauges = l.length;
									$scope.updatingGauges = false;
									for (var i = 0; i < l.length; i++)
										$scope.drawGauge('meta' + (i + 1),
												l[i].nome, l[i].valor,
												l[i].descricao,
												l[i].memoriaDeCalculo);
								}, function errorCallback(response) {
								}));

						$scope.$parent.promise
								.push($http({
									url : urlBase + "/metas/especificas",
									method : "GET"
								})
										.then(
												function successCallback(
														response) {
													var l = response.data.list;
													$scope.countGaugesMetaEspecifica = l.length;
													$scope.updatingGaugesMetaEspecifica = false;
													for (var i = 0; i < l.length; i++)
														$scope
																.drawGauge(
																		'metaespecifica'
																				+ (i + 1),
																		l[i].nome,
																		l[i].valor,
																		l[i].descricao,
																		l[i].memoriaDeCalculo);
												},
												function errorCallback(response) {
												}));
					}

					$scope.drawGauge = function(idCanvas, name, value, descr,
							calc) {
						var gauge = $scope.gauges[idCanvas];
						if (!gauge) {
							var opts = {
								angle : -0.15, // The span of the gauge arc
								lineWidth : 0.20, // The line thickness
								radiusScale : 1, // Relative radius
								pointer : {
									length : 0.49, // // Relative to gauge
									// radius
									strokeWidth : 0.049, // The thickness
									color : '#000000' // Fill color
								},
								limitMax : true, // If false, the max value
								// of the gauge will
								// be updated
								// if value surpass max
								limitMin : true, // If true, the min value of
								// the gauge will
								// be fixed
								// unless you set it manually
								colorStart : '#6FADCF', // Colors
								colorStop : '#8FC0DA', // just experiment with
								// them
								strokeColor : '#E0E0E0', // to see which ones
								// work best for
								// you
								generateGradient : true,
								highDpiSupport : true,
								staticZones : [ {
									strokeStyle : "#F03E3E",
									min : 0,
									max : 80
								}, // Red from 100 to 130
								{
									strokeStyle : "#FFDD00",
									min : 80,
									max : 120
								}, // Yellow
								{
									strokeStyle : "#30B32D",
									min : 120,
									max : 200
								}, // Green
								],
								staticLabels : {
									font : "10px sans-serif",
									labels : [ 80, 120 ],
									color : "#000000",
									fractionDigits : 0
								},
							};

							var target = $('#' + idCanvas + ' > div > canvas')[0];
							gauge = new Gauge(target).setOptions(opts);
							gauge.setTextField($('#' + idCanvas
									+ ' > div > div > span.meta-valor')[0]);
							gauge.maxValue = 200;
							gauge.setMinValue(0);
							gauge.animationSpeed = 32;
							$scope.gauges[idCanvas] = gauge;
						}
						// Quando o valor é maior que 200%, o gauge apresenta
						// apenas 200%, pois está limitado, por isso, precesamos
						// apresentar um símbolode "maior do que".
						$('#' + idCanvas + ' > div > div > span.meta-sinal')
								.text(value > 200 ? "> " : "");
						$('#' + idCanvas + ' > h4').html(name);
						$('#' + idCanvas + ' > h4').attr('title', descr)
								.tooltip('dispose').tooltip()
						$('#' + idCanvas + ' > div > canvas').attr('title',
								calc).tooltip('dispose').tooltip();
						gauge.set(value); // set actual value
					}

					$scope.updatePieChart = function(d, l) {
						d.splice(1, d.length - 1);
						if (l === undefined) {
							d.push([ '', '' ]);
							return;
						}
						for (var i = 0; i < l.length; i++) {
							d.push([ l[i].nome, l[i].valor ]);
						}
					}

					$scope.updateColumnChart = function(chart, l) {
						var TITULO_LINHA = "Dia"
						var LINHA = "grupo";
						var COLUNA = "nome";
						var VALOR = "valor";

						chart.data = [ [ '', '' ], [ '', 0 ] ];
						if (l === undefined || l.length == 0) {
							return;
						}

						var lines = [];
						var columns = [];
						var cache = {};

						for (var i = 0; i < l.length; i++) {
							if (lines.indexOf(l[i][LINHA]) == -1) {
								lines.push(l[i][LINHA]);
								cache[l[i][LINHA]] = {};
							}
							if (columns.indexOf(l[i][COLUNA]) == -1) {
								columns.push(l[i][COLUNA]);
							}
							cache[l[i][LINHA]][l[i][COLUNA]] = l[i][VALOR];
						}

						var data = [];
						var firstline = [ TITULO_LINHA ];
						for (var c = 0; c < columns.length; c++) {
							firstline.push(columns[c]);
						}
						data.push(firstline);
						for (var l = 0; l < lines.length; l++) {
							var line = [ lines[l] ];
							for (var c = 0; c < columns.length; c++) {
								line.push(cache[lines[l]][columns[c]] || 0);
							}
							data.push(line);
						}
						// d = data;
						chart.data = data;
					}

					$scope.metasChart = {
						type : "Gauges",
						options : {
							max : 200,
							redFrom : 0,
							redTo : 80,
							yellowFrom : 80,
							yellowTo : 120,
							greenFrom : 120,
							greenTo : 200,
							minorTicks : 5
						},
						data : [ [ 'Label', 'Value' ] ]

					};

					$scope.pendenciasChart = {
						type : "PieChart",
						options : {
							legend : {
								position : 'top',
								maxLines : 3
							},
						// is3D: false,
						// pieHole: 0.4
						},
						data : [ [ 'Tipo', 'Quantidade' ] ]
					};

					$scope.documentosChart = {
						type : "ColumnChart",
						options : {
							legend : {
								position : 'top',
								maxLines : 3
							},
							bar : {
								groupWidth : '75%'
							},
							isStacked : true,
						},
						data : [ [ '', '' ], [ '', 0 ] ]
					};

					$scope.acervoChart = {
						type : "PieChart",
						options : {
							legend : {
								position : 'top',
								maxLines : 2
							}
						},
						data : [ [ 'Suporte', 'Quantidade' ] ]
					};

					$scope.composeErrorMessage = function(errordata) {
						var msg = "Erro.";
						try {
							if (errordata.hasOwnProperty("errordetails")) {
								var detail = {
									presentable : false,
									logged : false
								};
								if (errordata.hasOwnProperty("errordetails")
										&& errordata.errordetails.length > 0) {
									detail = errordata.errordetails[errordata.errordetails.length - 1];
									msg = "Não foi possível " + detail.context;
								}
								if (errordata.hasOwnProperty("errormsg")
										&& detail.presentable)
									msg = errordata.errormsg;
								if (detail.logged)
									msg += ", a TI já foi notificada.";
							} else if (errordata.hasOwnProperty("errormsg")) {
								msg = errormsg;
							}
						} catch (err) {

						}
						return msg;
					}

					$scope.presentError = function(id) {
						$scope.showErrorDetails = true;
						$scope.currentErrorId = id;
					}

					$scope.setError = function(response) {
						if (response === undefined) {
							delete $scope.errorDetails.geral;
							return;
						}
						var data;
						if (typeof response === 'string')
							data = {
								errormsg : response
							};
						else {
							data = response.data;
							if (response.data == null
									&& typeof response.statusText === 'string'
									&& response.statusText != '')
								data = {
									errormsg : response.statusText
								};
							else if (response.data == null
									&& typeof response.status === 'number')
								data = {
									errormsg : "http status " + response.status
								};
							else if (data != null
									&& (typeof data.errormsg == 'string')
									&& data.errormsg.lastIndexOf(
											"O conjunto de chaves não", 0) === 0)
								data.errormsg = $scope.errorMsgMissingCertificate;
						}
						$scope.errorDetails.geral = data;
					}

					var stop;

					$scope.init = function() {
						$('[data-toggle="tooltip"]').tooltip();

						stop = $interval($scope.update, 15 * 1000 * 60);
					}

					$scope.stopTimer = function() {
						if (angular.isDefined(stop)) {
							$interval.cancel(stop);
							stop = undefined;
						}
					};

					$scope.$on('$destroy', function() {
						$scope.stopTimer();
					});

					$timeout($scope.init, 10);
				});
