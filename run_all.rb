require 'open3'
require 'json'
require 'erb'
require 'fileutils'
$VERBOSE = nil

# ✅ MÉTODO PARA CONTAR RESUMEN DE FEATURES Y ESCENARIOS
def count_summary(data)
  total_features = data.size
  total_scenarios = data.sum { |f| f["elements"]&.count || 0 }
  passed = data.sum do |f|
    f["elements"].count { |s| s["steps"].all? { |step| step["result"]["status"] == "passed" } }
  end
  [total_features, total_scenarios, passed]
end

# Colores
COLOR_RESET  = "\e[0m"
COLOR_GREEN  = "\e[32m"
COLOR_YELLOW = "\e[33m"
COLOR_RED    = "\e[31m"

# Asegurar carpeta de logs
FileUtils.mkdir_p('logs')
FileUtils.mkdir_p('allure-results/android')
FileUtils.mkdir_p('allure-results/ios')

# ======================
# Lanzar servidor Appium
# ======================
def start_appium(port, log_file)
  puts "🔄 Iniciando Appium en el puerto #{port}..."
  Open3.popen2e("appium --port #{port}") do |stdin, stdout_err, wait_thr|
    File.open(log_file, 'w') do |file|
      stdout_err.each { |line| file.puts line }
    end
    sleep 5
    yield
    Process.kill('KILL', wait_thr.pid) if wait_thr.alive?
  end
end

# ======================
# Ejecutar pruebas
# ======================
def run_tests(platform, port)
  line = "=" * 60
  log_prefix = platform == 'android' ? '[ANDROID]' : '[IOS]'
  color_prefix = platform == 'android' ? COLOR_GREEN : COLOR_YELLOW

  puts "\n#{line}"
  puts "#{color_prefix}🚀 INICIANDO PRUEBAS #{platform.upcase} EN PUERTO #{port}#{COLOR_RESET}"
  puts "#{line}"

  json_output = "logs/#{platform}_results.json"
  cmd = "APPIUM_PORT=#{port} PLATFORM=#{platform} bundle exec cucumber --format pretty --format json --out #{json_output}"

  File.open("logs/#{platform}.log", 'w') do |log_file|
    output_lines = []
    log_file.puts line
    log_file.puts "#{log_prefix} 🚀 INICIANDO PRUEBAS #{platform.upcase} EN PUERTO #{port}"
    log_file.puts line

    Open3.popen2e(cmd) do |_stdin, stdout_err, _wait_thr|
      stdout_err.each do |line|
        formatted = "#{log_prefix} #{line.strip}"
        output_lines << formatted
        log_file.puts formatted
      end
    end

    output_lines.each do |line|
      next if line.strip.empty?
      highlight = line.match?(/(timed out|fail|Error::|Exception)/i)
      color = highlight ? COLOR_RED : color_prefix
      puts "#{color}#{line}#{COLOR_RESET}"
    end

    summary = output_lines.select { |l| l.match?(/scenarios? \(.+\)/i) || l.match?(/steps? \(.+\)/i) }
    puts "#{color_prefix}#{log_prefix} 🧾 RESUMEN DE RESULTADOS#{COLOR_RESET}"
    summary.each do |l|
      color = l.include?("failed") ? COLOR_RED : color_prefix
      puts "#{color}#{l}#{COLOR_RESET}"
      log_file.puts l
    end

    log_file.puts "#{log_prefix} ✅ FINALIZADAS PRUEBAS #{platform.upcase}"
    log_file.puts line
  end
end

# ======================
# Generar reporte HTML
# ======================
def generate_html_report
  template_path = File.join(__dir__, 'plantillas', 'graph_report.html.erb')
  unless File.exist?(template_path)
    puts "❌ Plantilla HTML no encontrada en #{template_path}"
    return
  end

  android_json = 'logs/android_results.json'
  ios_json     = 'logs/ios_results.json'

  android_data = File.exist?(android_json) ? JSON.parse(File.read(android_json)) : []
  ios_data     = File.exist?(ios_json) ? JSON.parse(File.read(ios_json)) : []

  erb_template = ERB.new(File.read(template_path))
  html_result = erb_template.result(binding)

  File.write('logs/TestMobile_Report.html', html_result)
  puts "\n📄 Reporte HTML generado en: logs/TestMobile_Report.html"
rescue => e
  puts "\n#{COLOR_RED}❌ Error generando el reporte HTML: #{e.message}#{COLOR_RESET}"
end

# ======================
# MAIN
# ======================

threads = []
parallel = ENV['PLATFORM'].nil?

if parallel
  threads << Thread.new do
    start_appium(4723, 'logs/appium_android.log') { run_tests('android', 4723) }
  end
  threads << Thread.new do
    start_appium(4725, 'logs/appium_ios.log') { run_tests('ios', 4725) }
  end
  threads.each(&:join)
else
  platform = ENV['PLATFORM']
  port = ENV['APPIUM_PORT'] || (platform == 'android' ? 4723 : 4725)
  run_tests(platform, port.to_i)
end

generate_html_report