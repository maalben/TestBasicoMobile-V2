require 'open3'

# Colores ANSI
COLOR_RESET = "\e[0m"
COLOR_GREEN = "\e[32m"
COLOR_YELLOW = "\e[33m"
COLOR_RED = "\e[31m"

def start_appium(port, log_file)
  puts "🔄 Iniciando Appium en el puerto #{port}..."
  Open3.popen2e("appium --port #{port}") do |stdin, stdout_err, wait_thr|
    File.open(log_file, 'w') do |file|
      stdout_err.each { |line| file.puts line }
    end
    sleep 5 # Esperar que Appium arranque bien
    yield
    Process.kill('KILL', wait_thr.pid) if wait_thr.alive?
  end
end

def run_tests(platform, port)
  line = "=" * 60
  puts "\n#{line}"
  puts "#{platform == 'android' ? COLOR_GREEN : COLOR_YELLOW}🚀 INICIANDO PRUEBAS #{platform.upcase} EN PUERTO #{port}#{COLOR_RESET}"
  puts "#{line}"

  cmd = "APPIUM_PORT=#{port} PLATFORM=#{platform} bundle exec cucumber"
  Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
    File.open("logs/#{platform}.log", 'w') do |log_file|
      log_prefix = platform == 'android' ? '[ANDROID]' : '[IOS]'
      color_prefix = platform == 'android' ? COLOR_GREEN : COLOR_YELLOW
      output_lines = []

      log_file.puts line
      log_file.puts "#{log_prefix} 🚀 INICIANDO PRUEBAS #{platform.upcase} EN PUERTO #{port}"
      log_file.puts line

      stdout_err.each do |line|
        formatted_line = "#{log_prefix} #{line.strip}"
        output_lines << formatted_line
        log_file.puts formatted_line
      end

      # Imprime todo el bloque después de terminar para evitar entremezclar salidas
      output_lines.each do |line|
        next if line.strip.empty?

        highlight = line.match?(/(timed out|NoSuchElementError|Error::|fail|Exception)/i)
        color = highlight ? COLOR_RED : color_prefix
        puts "#{color}#{line}#{COLOR_RESET}"
      end

      # Extraer resumen final de resultados
      summary_lines = output_lines.select { |l| l.match?(/scenarios? \(.+\)/i) || l.match?(/steps? \(.+\)/i) }
      summary_header = "#{log_prefix} 🧾 RESUMEN DE RESULTADOS"
      summary_block = [summary_header] + summary_lines

      summary_block.each do |line|
        color = line.include?("failed") ? COLOR_RED : color_prefix
        puts "#{color}#{line}#{COLOR_RESET}"
        File.open("logs/#{platform}.log", 'a') { |log_file| log_file.puts line }
      end

      log_file.puts "#{log_prefix} ✅ FINALIZADAS PRUEBAS #{platform.upcase}"
      log_file.puts line
    end
  end

  puts "#{platform == 'android' ? COLOR_GREEN : COLOR_YELLOW}✅ FINALIZADAS PRUEBAS #{platform.upcase}#{COLOR_RESET}"
  puts line
end

# Lanza ambos en paralelo
threads = []

threads << Thread.new do
  start_appium(4723, 'logs/appium_android.log') do
    run_tests('android', 4723)
  end
end

threads << Thread.new do
  start_appium(4725, 'logs/appium_ios.log') do
    run_tests('ios', 4725)
  end
end

threads.each(&:join)

# Resumen global
def extract_summary(path)
  File.readlines(path).select { |line| line.match?(/scenarios? \(.+\)/i) || line.match?(/steps? \(.+\)/i) }
end

android_summary = extract_summary('logs/android.log')
ios_summary = extract_summary('logs/ios.log')

puts "\n" + ("=" * 60)
puts "📊 RESUMEN GLOBAL DE RESULTADOS"
puts ("=" * 60)
android_color = android_summary.any? { |l| l.include?("failed") } ? COLOR_RED : COLOR_GREEN
ios_color = ios_summary.any? { |l| l.include?("failed") } ? COLOR_RED : COLOR_YELLOW

puts "#{android_color}[ANDROID]#{COLOR_RESET} #{android_summary.join.strip}"
puts "#{ios_color}[IOS]#{COLOR_RESET} #{ios_summary.join.strip}"
puts ("=" * 60)

puts "\n✅ ¡Ejecución completa para Android e iOS!"
puts "📝 Revisa los logs en la carpeta /logs"